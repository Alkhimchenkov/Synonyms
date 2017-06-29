//
//  ApiData.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ApiData.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "Reachability.h"

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

static NSString *const kApiLinkWord  = @"http://words.bighugelabs.com/api/2";
static NSString *const kApikey = @"878a9a751f0764ed2d800b6f4bf70303";
static NSString *const kApiTypeResult = @"json";

@interface ApiData ()
{
    Reachability *internetReachableFoo;
}

@end


@implementation ApiData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataRequest  = nil;
        _resultSearch = NO;
        _activeSave   = NO;
    }
    return self;
}

#pragma mark - get offile and online 
-(BOOL)getSearchSynonyms:(NSString*)word{
    if ([GLOBAL_APP_DELEGATE isNet])
        self.resultSearch = [self requestFromServer:[ApiData getUrl:word]];
     else
        self.resultSearch = [self requestDataModel:word];
    
    return self.resultSearch;
    
}


#pragma mark - Api Methods
-(BOOL)requestFromServer:(NSURL*)urlString{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    [request setHTTPMethod:@"GET"];
    NSData *data = [ApiData sendSynchronousRequest:request];
    if (data) {
        self.dataRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        return YES;
    }
    return NO;
}

+(NSURL*)getUrl:(NSString*)word {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@",kApiLinkWord, kApikey, word, kApiTypeResult]];
}


+(NSData*)sendSynchronousRequest:(NSURLRequest*)request{
    
    dispatch_semaphore_t sem;
    
    __block NSData *result;
    
    result = nil;
    
    sem = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         
                                         if (error) {
                                             //  NSLog(@"dataTaskWithRequest errors: %@", error);
                                             return;
                                         }
                                         
                                         if ([response isKindOfClass:[NSHTTPURLResponse class]]){
                                             NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
                                             
                                             if (statusCode == 200)
                                                 result = data;
                                             
                                         }
                                         
                                         dispatch_semaphore_signal(sem);
                                     }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return result;
}



#pragma mark - connect Internet
-(void)internetConnect{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [GLOBAL_APP_DELEGATE setIsNet:YES];
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [GLOBAL_APP_DELEGATE setIsNet:NO];
        });
    };
    [internetReachableFoo startNotifier];
}


#pragma mark - Data Model Synonyms

-(NSArray*)getResultFromDataModel:(BOOL)singleData fromText:(NSString*)text{

    NSManagedObjectContext *context = [[GLOBAL_APP_DELEGATE persistentContainer] viewContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Synonyms"];
    
    singleData ? [request setPredicate:[NSPredicate predicateWithFormat:@"key == %@", text]]: nil;
    
    NSError *error;

    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result) {
        NSAssert(NO, @"Error request context:%@\n%@",[error localizedDescription], [error userInfo]);
        return nil;
    } else {
        return result;
    }

}

-(BOOL)requestDataModel:(NSString*)text{
    
    NSArray *result = [self getResultFromDataModel:YES fromText:text];
    if ((result) && (result.count != 0)){
        self.dataRequest = @{[[result objectAtIndex:0] valueForKey:@"key"]:@{@"syn":[self data:[[result objectAtIndex:0] valueForKey:@"dataSyn"]]}};
        return YES;
    }

    return NO;
}

-(void)getDataFromBase{

    NSArray *result = [self getResultFromDataModel:NO fromText:@""];
    
    if (result)
        for (NSManagedObject *obj in result) {
            [[DataProvider sharedInstance] addSaveData:@[@{[obj valueForKey:@"key"]:[self data:[obj valueForKey:@"dataSyn"]]}]];
        }
}

-(void)updateBase:(NSString*)key data:(NSArray*)data{

    NSManagedObjectContext *context = [[GLOBAL_APP_DELEGATE persistentContainer] viewContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Synonyms" inManagedObjectContext:context];
    NSManagedObject *synonyms = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    [synonyms setValue:key forKeyPath:@"key"];
    [synonyms setValue:[self jsonString:data] forKeyPath:@"dataSyn"];
    
    NSError *error;
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Error saving context:%@\n%@",[error localizedDescription], [error userInfo]);
    } else {
        [[DataProvider sharedInstance] addSaveData:@[@{key:data}]];
    }
}


-(void)deleteDataModel:(NSString*)key{
    NSError *error;
    NSArray *result = [self getResultFromDataModel:YES fromText:key];
    if (result) {
        [[[GLOBAL_APP_DELEGATE persistentContainer] viewContext] deleteObject:[result objectAtIndex:0]];
        [[[GLOBAL_APP_DELEGATE persistentContainer] viewContext] save:&error];
    }
}


-(NSArray*)data:(NSString*)jsonString{
    return [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}


-(NSString*)jsonString:(NSArray*)fromData{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fromData options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}




@end

//
//  DataProvider.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "DataProvider.h"

static DataProvider *sharedInstance;


@interface DataProvider () {
    NSMutableArray *_dataHistoryRequest;
    NSArray *_dataSearchResult;
    NSMutableArray *_dataSave;
    NSArray *_dataDetailItem;
    NSString *_title;
}
@end


@implementation DataProvider

+ (instancetype)sharedInstance
{
    if (sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}


#pragma mark - private methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataHistoryRequest  = [[NSMutableArray alloc] init];
        _dataSave            = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - methods Set and Get data

#pragma mark - history
- (NSArray *)getHistoryRequest{
    return [NSArray arrayWithArray:_dataHistoryRequest];
}

- (void)setHistoryRequest:(NSString *)newHistoryRequest{
    [_dataHistoryRequest addObject:newHistoryRequest];
}

#pragma mark  - result search to save
-(void)setNewItemToSave:(NSArray*)newItem{
    _dataSearchResult = [NSArray arrayWithArray:newItem];
}

-(NSArray*)getNewItemToSave{
    return _dataSearchResult;
}


#pragma mark - save data
-(void)addSaveData:(NSArray*)dataSave{
    [_dataSave addObjectsFromArray:dataSave];
}

-(NSArray*)getSaveData{
    return _dataSave;
}

- (void)setSaveData:(NSArray*)dataSave{
    _dataSave = [NSMutableArray arrayWithArray:dataSave];
}

-(void)deleteDataSave:(NSInteger)index{
    [_dataSave removeObjectAtIndex:index];
}


#pragma mark - detail data
-(void)setDetailDataItem:(NSArray*)detailDataItem{    
    _dataDetailItem = [NSArray arrayWithArray:detailDataItem];
}
-(NSArray *)getDetailDataItem{
    return _dataDetailItem;
}

#pragma mark - title detail
- (void)setDetailTitle:(NSString*)title{
    _title = title;

}

- (NSString*)getDetailTitle{
    return _title;
}

#pragma mark - search key in save data
- (BOOL)getActiveSave:(NSString*)keyText{
    
    for (NSDictionary *key in _dataSave) {
        if ([[keyText uppercaseString] isEqualToString:[[[key allKeys] firstObject] uppercaseString]]){
            return NO;
        }
    }
        
    return YES;
}


@end

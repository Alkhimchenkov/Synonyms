//
//  ApiData.h
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface ApiData : NSObject

@property (strong, nonatomic) NSDictionary *dataRequest;
@property (assign, nonatomic) BOOL resultSearch;
@property (assign, nonatomic) BOOL activeSave;



-(BOOL)getSearchSynonyms:(NSString*)word;
-(void)internetConnect;

//-(BOOL)requestFromServer:(NSURL*)urlString;
//-(BOOL)requestDataModel:(NSString*)text;

-(void)deleteDataModel:(NSString*)key;
-(void)updateBase:(NSString*)key data:(NSArray*)data;
-(void)getDataFromBase;

+(NSURL*)getUrl:(NSString*)word;

@end

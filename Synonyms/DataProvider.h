//
//  DataProvider.h
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)getHistoryRequest;
- (void)setHistoryRequest:(NSString *)newHistoryRequest;

- (void)addSaveData:(NSArray*)dataSave;
- (NSArray *)getSaveData;
- (void)setSaveData:(NSArray*)dataSave;
- (void)deleteDataSave:(NSInteger)index;

- (void)setDetailDataItem:(NSArray*)detailDataItem;
- (NSArray *)getDetailDataItem;

- (void)setDetailTitle:(NSString*)title;
- (NSString*)getDetailTitle;


- (void)setNewItemToSave:(NSArray*)newItem;
- (NSArray*)getNewItemToSave;

- (BOOL)getActiveSave:(NSString*)keyText;

@end

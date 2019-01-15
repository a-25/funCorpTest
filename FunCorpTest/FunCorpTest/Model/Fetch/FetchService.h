//
//  FetchService.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterfallItemListService.h"
#import "DatabaseService.h"
#import "Realm/Realm.h"
#import "WaterfallItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FetchService : NSObject

@property(nonatomic, strong) DatabaseService *databaseService;
@property(nonatomic, strong) WaterfallItemListService *waterfallItemListService;
@property(nonatomic, readonly) RLMResults* itemList;

- (instancetype)initWithDatabaseService:(DatabaseService*)databaseService andWaterfallItemListService:(WaterfallItemListService*)itemListService NS_DESIGNATED_INITIALIZER;
-(BOOL)isDataFetchedForItem:(WaterfallItemObject*)item;
-(void)fetchAsync:(WaterfallItemObject*)item completion:(nullable void (^)(WaterfallItemObject *item))completion;

@end

NS_ASSUME_NONNULL_END

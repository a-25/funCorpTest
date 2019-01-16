//
//  PlanService.h
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseService.h"
#import "PictureStoreService.h"
#import "WaterfallItemListService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlanService : NSObject

@property(nonatomic) unsigned long currentPosition;
@property(nonatomic, strong) PictureStoreService* storeService;
@property(nonatomic, strong) DatabaseService* databaseService;
@property(nonatomic) unsigned long forwardFetchSize;
@property(nonatomic) unsigned long loadSize;
- (instancetype)initWithStoreService:(DatabaseService*)databaseService andItemListService:(WaterfallItemListService*)itemListService NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

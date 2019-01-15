//
//  DIService.h
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterfallItemStoreService.h"
#import "WaterfallItemListService.h"
#import "PlanService.h"
#import "FetchService.h"
#import "DatabaseService.h"

NS_ASSUME_NONNULL_BEGIN

@interface DIService : NSObject

+(DIService*)sharedInstance;

@property(nonatomic,strong,readonly) DatabaseService *databaseService;
@property(nonatomic,strong,readonly) WaterfallItemStoreService *waterfallItemStoreService;
@property(nonatomic,strong,readonly) WaterfallItemListService *waterfallItemListService;
@property(nonatomic,strong,readonly) PlanService *planService;
@property(nonatomic,strong,readonly) FetchService *fetchService;
@property(nonatomic) unsigned short colsCount;
//@property(nonatomic) unsigned short defaultPortion;
@property(nonatomic, strong) NSString *pixabayApiKey;

@end

NS_ASSUME_NONNULL_END

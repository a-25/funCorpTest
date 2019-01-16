//
//  DIService.h
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureStoreService.h"
#import "WaterfallItemListService.h"
#import "PlanService.h"
#import "FetchService.h"
#import "DatabaseService.h"
#import "WaterfallItemCreateService.h"
#import "AdsImportService.h"
#import "AdsCreateService.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const notificationSettingsChanged = @"notificationSettingsChanged";

@interface DIService : NSObject

+(DIService*)sharedInstance;

@property(nonatomic,strong,readonly) DatabaseService *databaseService;
@property(nonatomic,strong,readonly) PictureStoreService *pictureStoreService;
@property(nonatomic,strong,readonly) WaterfallItemListService *waterfallItemListService;
@property(nonatomic,strong,readonly) PlanService *planService;
@property(nonatomic,strong,readonly) FetchService *fetchService;
@property(nonatomic,strong,readonly) WaterfallItemCreateService *waterfallItemCreateService;
@property(nonatomic,strong,readonly) AdsImportService *adsImportService;
@property(nonatomic,strong,readonly) AdsCreateService *adsCreateService;
@property(nonatomic) unsigned short colsCount;
@property(nonatomic, strong) NSString *pixabayApiKey;

@end

NS_ASSUME_NONNULL_END

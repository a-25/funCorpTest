//
//  AdsImportService.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsCreateService.h"
#import "DatabaseService.h"
#import "WaterfallItemListService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdsImportService : NSObject

@property(nonatomic, strong) AdsCreateService *adsCreateService;
@property(nonatomic, strong) DatabaseService *databaseService;
@property(nonatomic, strong) WaterfallItemListService *waterfallItemListService;
@property(nonatomic, readonly) BOOL isActivated;
@property(nonatomic) unsigned short interval;

- (instancetype)initWithDatabaseService:(DatabaseService*)databaseService andAdsCreateService:(AdsCreateService*)adsCreateService andWaterfallItemListService:(WaterfallItemListService*)waterfallItemListService andInterval:(unsigned short)interval NS_DESIGNATED_INITIALIZER;

-(void)start;
-(void)stop;

@end

NS_ASSUME_NONNULL_END

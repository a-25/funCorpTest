//
//  DIService.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "DIService.h"

@implementation DIService

+(DIService*)sharedInstance
{
    static DIService *diServiceInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        diServiceInstance = [[self alloc] init];
    });
    return diServiceInstance;
}

- (id)init
{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    _colsCount = 3;
    _pixabayApiKey = @"11279126-f72f121dda9da0d41789c9986";
    [self initDatabaseService];
    [self initWaterfallItemCreateService];
    [self initAdsCreateService];
    [self initPictureStoreService];
    [self initWaterfallItemListService];
    [self initPlanService];
    [self initAdsImportService];
}

-(void)initDatabaseService
{
    _databaseService = [[DatabaseService alloc] init];
}

-(void)initPictureStoreService
{
    _pictureStoreService = [[PictureStoreService alloc] init];
    _pictureStoreService.databaseService = _databaseService;
    _pictureStoreService.apiKey = _pixabayApiKey;
    _pictureStoreService.waterfallItemCreateService = _waterfallItemCreateService;
}

-(void)initWaterfallItemListService
{
    _waterfallItemListService = [[WaterfallItemListService alloc] init];
}

-(void)initPlanService
{
    _planService = [[PlanService alloc] initWithStoreService:_databaseService andItemListService:_waterfallItemListService];
    _planService.storeService = _pictureStoreService;
    unsigned long prefetchPageSize = 100;
    _planService.forwardFetchSize = prefetchPageSize;
    _planService.loadSize = prefetchPageSize;
}

-(void)initWaterfallItemCreateService
{
    _waterfallItemCreateService = [[WaterfallItemCreateService alloc] init];
}

-(void)initAdsImportService
{
    _adsImportService = [[AdsImportService alloc] initWithDatabaseService:_databaseService
                                                      andAdsCreateService:_adsCreateService
                                              andWaterfallItemListService: _waterfallItemListService
                                                              andInterval:20];
}

-(void)initAdsCreateService
{
    _adsCreateService = [[AdsCreateService alloc] init];
    _adsCreateService.waterfallItemCreateService = _waterfallItemCreateService;
}

@end

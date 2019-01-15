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
    _colsCount = 2;
    _pixabayApiKey = @"11279126-f72f121dda9da0d41789c9986";
    [self initDatabaseService];
    [self initWaterfallItemStoreService];
    [self initWaterfallItemListService];
    [self initPlanService];
}

-(void)initDatabaseService
{
    _databaseService = [[DatabaseService alloc] init];
}

-(void)initWaterfallItemStoreService
{
    _waterfallItemStoreService = [[WaterfallItemStoreService alloc] init];
    _waterfallItemStoreService.databaseService = _databaseService;
    _waterfallItemStoreService.apiKey = _pixabayApiKey;
}

-(void)initWaterfallItemListService
{
    _waterfallItemListService = [[WaterfallItemListService alloc] init];
}

-(void)initPlanService
{
    _planService = [[PlanService alloc] initWithStoreService:_databaseService andItemListService:_waterfallItemListService];
    _planService.storeService = _waterfallItemStoreService;
}

@end

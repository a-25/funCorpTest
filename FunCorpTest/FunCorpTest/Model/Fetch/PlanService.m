//
//  PlanService.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "PlanService.h"

//@TODO. Move to properties
const unsigned short forwardFetchSize = 5;
const unsigned short loadSize = 10;

@interface PlanService()

@property(nonatomic) unsigned long loadedInDatabaseNumber;

@end

@implementation PlanService

-(id)init
{
    @throw nil;
}

- (instancetype)initWithStoreService:(DatabaseService*)databaseService andItemListService:(WaterfallItemListService*)itemListService
{
    if (self = [super init]){
        _currentPosition = 0;
        _databaseService = databaseService;
        _itemListService = itemListService;
        _loadedInDatabaseNumber = [itemListService listNumber:[databaseService getRealm]];
    }
    return self;
}

- (void)setCurrentPosition:(unsigned long)currentPosition
{
    _currentPosition = currentPosition;
    if(currentPosition > _loadedInDatabaseNumber - forwardFetchSize) {
        [self loadNext];
    }
}

-(void)loadNext
{
    int currentPage = floor(_loadedInDatabaseNumber/loadSize);
    [_storeService importFromApi:currentPage andPerPage:loadSize];
}

@end

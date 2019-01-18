//
//  PlanService.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "PlanService.h"

@interface PlanService()
{
    RLMNotificationToken *notificationToken;
}

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
        [self bindUpdateNotifications: [itemListService list:[databaseService getRealm]]];
    }
    return self;
}

- (void)dealloc {
    [self->notificationToken invalidate];
}

-(void)bindUpdateNotifications:(RLMResults*)list
{
    __weak typeof(self) weakSelf = self;
    self->notificationToken = [list addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to open Realm in notification block: %@", error);
            return;
        }
        
        weakSelf.loadedInDatabaseNumber = results.count;
    }];
}

- (void)setCurrentPosition:(unsigned long)currentPosition
{
//    if(_currentPosition == currentPosition) {
//        return;
//    }
    
    _currentPosition = currentPosition;
    if(currentPosition > self.loadedInDatabaseNumber - self.forwardFetchSize || self.loadedInDatabaseNumber < self.forwardFetchSize) {
        [self loadNext: self.loadedInDatabaseNumber];
    }
}

-(void)loadNext:(unsigned long)loadedInDatabaseNumber
{
    int currentPage = floor(loadedInDatabaseNumber/self.loadSize);
    [_storeService importFromApi:currentPage andPerPage:self.loadSize];
}

@end

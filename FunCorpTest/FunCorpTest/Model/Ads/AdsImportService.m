//
//  AdsImportService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "AdsImportService.h"

@interface AdsImportService()
{
    NSTimer *createTimer;
}

@end

@implementation AdsImportService

-(id)init
{
    @throw nil;
}

- (instancetype)initWithDatabaseService:(DatabaseService*)databaseService andAdsCreateService:(AdsCreateService*)adsCreateService andInterval:(unsigned short)interval
{
    if (self = [super init]){
        _databaseService = databaseService;
        _interval = interval;
        _adsCreateService = adsCreateService;
    }
    return self;
}

-(void)start
{
    _isActivated = YES;
    [self->createTimer invalidate];
    self->createTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                         target:self
                                                       selector:@selector(onTimer)
                                                       userInfo:nil
                                                        repeats:YES];
}

-(void)stop
{
    _isActivated = NO;
    [self->createTimer invalidate];
}

-(void)onTimer
{
    if(!_isActivated){
        return;
    }
    __weak AdsImportService *weakSelf = self;
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [weakSelf.databaseService getRealm];
            [realm beginWriteTransaction];
            [weakSelf.adsCreateService createInRealm:realm];
            [realm commitWriteTransaction];
        }
    });
}
@end

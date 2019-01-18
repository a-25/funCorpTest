//
//  DatabaseService.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "DatabaseService.h"

@implementation DatabaseService

-(id)init
{
    if(self = [super init]) {
        _multithreadLock = dispatch_semaphore_create(1);
        RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
        //For test projects it's ok, not for production ones
        configuration.deleteRealmIfMigrationNeeded = YES;
        [RLMRealmConfiguration setDefaultConfiguration:configuration];
    }
    return self;
}

-(RLMRealm*)getRealm
{
    dispatch_semaphore_wait(self.multithreadLock, DISPATCH_TIME_FOREVER);
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm refresh];
    dispatch_semaphore_signal(self.multithreadLock);
    return realm;
}

@end

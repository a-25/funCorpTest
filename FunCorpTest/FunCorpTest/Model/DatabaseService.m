//
//  DatabaseService.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "DatabaseService.h"
//#import "Defer.h"

//@interface DatabaseService(Private)
//
//@property(nonatomic, strong) dispatch_semaphore_t multithreadLock;
//
//@end

@implementation DatabaseService

-(id)init
{
    if(self = [super init]) {
        _multithreadLock = dispatch_semaphore_create(1);
    }
    return self;
}

//-(void)dealloc
//{
//    dispatch_release(self.multithreadLock);
//}

-(RLMRealm*)getRealm
{
    dispatch_semaphore_wait(self.multithreadLock, DISPATCH_TIME_FOREVER);
//    defer(^() {
//        dispatch_semaphore_signal(self.multithreadLock);
//    });
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm refresh];
    dispatch_semaphore_signal(self.multithreadLock);
    return realm;
}

@end

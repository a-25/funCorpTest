//
//  DatabaseService.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/Realm.h"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseService : NSObject

@property(nonatomic, strong) dispatch_semaphore_t multithreadLock;
-(RLMRealm*)getRealm;

@end

NS_ASSUME_NONNULL_END

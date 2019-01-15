//
//  Defer.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef (void (^)(void)) DeferBlock;

@interface Defer : NSObject

+ (instancetype)defer:(void (^)(void))block;
@property(nonatomic) DeferBlock *block;

@end

void defer(void (^block)(void)) {
    static Defer* __weak d;
    d = [Defer defer:block];
}

NS_ASSUME_NONNULL_END

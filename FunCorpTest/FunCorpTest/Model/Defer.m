//
//  Defer.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "Defer.h"

@implementation Defer

+ (instancetype)defer:(void (^)(void))block {
    Defer* defer =  [[Defer alloc] init];
    defer.block = block;
    return defer;
}

- (void)dealloc {
    if (_block) {
        _block();
    }
}

@end

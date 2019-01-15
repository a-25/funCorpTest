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
}

@end

//
//  PlanService.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "PlanService.h"

@implementation PlanService

- (id)init
{
    if (self = [super init]){
        _currentPosition = 0;
    }
    return self;
}

- (void)setCurrentPosition:(int)currentPosition
{
    _currentPosition = currentPosition;
    [self load:currentPosition];
}

-(void)load:(int)currentPosition
{
//    int 
}

@end

//
//  AdsCreateService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "AdsCreateService.h"
#import "UniqueHashGenerator.h"

@implementation AdsCreateService

-(AdsObject*)createInRealm:(RLMRealm*)realm
{
    AdsObject *obj = [[AdsObject alloc] init];
    obj.id = [UniqueHashGenerator generate:nil];
    obj.title = @"Ads:\nЗдесь могла быть ваша реклама";
    [realm addObject:obj];
    [self.waterfallItemCreateService createWithAds:obj inRealm:realm];
    return obj;
}

@end

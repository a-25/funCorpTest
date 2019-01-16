//
//  WaterfallItemCreateService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallItemCreateService.h"
#import "UniqueHashGenerator.h"

@implementation WaterfallItemCreateService

-(WaterfallItemObject*)createWithPicture:(PictureObject*)picture inRealm:(RLMRealm*)realm
{
    WaterfallItemObject *obj = [self createEmpty:realm];
    obj.picture = picture;
    return obj;
}

-(WaterfallItemObject*)createWithAds:(AdsObject*)ads inRealm:(RLMRealm*)realm
{
    WaterfallItemObject *obj = [self createEmpty:realm];
    obj.ads = ads;
    return obj;
}

-(WaterfallItemObject*)createEmpty:(RLMRealm*)realm
{
    WaterfallItemObject *obj = [[WaterfallItemObject alloc] init];
    obj.id = [UniqueHashGenerator generate:nil];
    obj.dateAdded = [NSDate dateWithTimeIntervalSinceNow:0];
    [realm addObject:obj];
    return obj;
}

@end

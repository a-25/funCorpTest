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
    long sortOrder = [WaterfallItemObject allObjectsInRealm:realm].count + 1;
    WaterfallItemObject *obj = [self createEmpty:realm];
    obj.picture = picture;
    obj.sortOrder = sortOrder;
    return obj;
}

-(WaterfallItemObject*)createWithAds:(AdsObject*)ads inRealm:(RLMRealm*)realm withSortOrder:(long)sortOrder
{
    //Update sortOrder of next items
    RLMResults *updateSortList = [WaterfallItemObject objectsWhere:@"sortOrder >= %ld", sortOrder];
    for(long i = 0; i < updateSortList.count; i++){
        WaterfallItemObject *item = (WaterfallItemObject*)updateSortList[i];
        item.sortOrder = item.sortOrder + 1;
        [realm addObject:item];
    }
    WaterfallItemObject *obj = [self createEmpty:realm];
    obj.ads = ads;
    obj.sortOrder = sortOrder;
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

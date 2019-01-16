//
//  WaterfallItemCreateService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallItemCreateService.h"

@implementation WaterfallItemCreateService

-(WaterfallItemObject*)createWithPicture:(PictureObject*)picture inRealm:(RLMRealm*)realm withSortOrder:(long)sortOrder
{
    WaterfallItemObject *obj = [self createEmpty:picture.imageUrl inRealm:realm];
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
    WaterfallItemObject *obj = [self createEmpty:ads.id inRealm:realm];
    obj.ads = ads;
    obj.sortOrder = sortOrder;
    return obj;
}

-(WaterfallItemObject*)createEmpty:(NSString*)id inRealm:(RLMRealm*)realm
{
    WaterfallItemObject *obj = [WaterfallItemObject objectInRealm:realm forPrimaryKey:id];
    if(!obj) {
        obj = [[WaterfallItemObject alloc] init];
        obj.id = id;
        obj.dateAdded = [NSDate dateWithTimeIntervalSinceNow:0];
        [realm addObject:obj];
    }
    return obj;
}

@end

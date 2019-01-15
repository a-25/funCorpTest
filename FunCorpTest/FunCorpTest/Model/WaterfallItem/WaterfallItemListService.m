//
//  WaterfallItemListService.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallItemListService.h"
#import "WaterfallItemObject.h"

@implementation WaterfallItemListService

-(RLMResults*)list:(RLMRealm*)realm
{
    return [[self getUnsortedList:realm] sortedResultsUsingKeyPath:@"sortOrder" ascending:YES];
}

-(unsigned long)listNumber:(RLMRealm*)realm
{
    return [self getUnsortedList:realm].count;
}

-(RLMResults*)getUnsortedList:(RLMRealm*)realm
{
    return [WaterfallItemObject allObjectsInRealm:realm];
}

@end

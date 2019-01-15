//
//  WaterfallItemPrefetcher.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallItemPrefetcher.h"
#import "WaterfallItemObject.h"

@implementation WaterfallItemPrefetcher

-(id)init
{
    @throw nil;
}

- (instancetype)initWithFetchService:(FetchService*)fetchService
{
    if(self = [super init]) {
        _fetchService = fetchService;
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    NSMutableArray<WaterfallItemObject *> *itemList = [NSMutableArray new];
    for (NSIndexPath *indexPath in indexPaths) {
        WaterfallItemObject *item = [self.fetchService.itemList objectAtIndex:indexPath.row];
        [itemList addObject:item];
    }
    [itemList enumerateObjectsUsingBlock:^(WaterfallItemObject *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.fetchService fetchAsync:item completion:nil];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    //@TODO. Implement this if needed
}

@end

//
//  WaterfallControllerDatasource.m
//  FunCorpTest
//
//  Created by A-25 on 18/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallControllerDataProvider.h"
#import "WaterfallItemCellProtocol.h"

@interface WaterfallControllerDataProvider()
{
    RLMNotificationToken *notificationToken;
}

@property(nonatomic, weak) UICollectionView *collectionView;

@end

@implementation WaterfallControllerDataProvider

-(id)init
{
    @throw nil;
}

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView andWaterfallScrollService:(WaterfallScrollService*)waterfallScrollService andItemList:(RLMResults<WaterfallItemObject*> *)itemList
{
    if (self = [super init]){
        _waterfallScrollService = waterfallScrollService;
        _itemList = itemList;
        _collectionView = collectionView;
        [self bindUpdateNotifications];
    }
    return self;
}

- (void)dealloc {
    [self->notificationToken invalidate];
}

-(void)bindUpdateNotifications
{
    __weak typeof(self) weakSelf = self;
    RLMResults *blockItemList = self.itemList;
    self->notificationToken = [self.itemList addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to open Realm in notification block: %@", error);
            return;
        }
        
        UICollectionView *collectionView = weakSelf.collectionView;
        // Initial run of the query will pass nil for the change information
        if (!change) {
            [collectionView reloadData];
            return;
        }
        
        NSIndexPath *firstVisibleIndexPath = [weakSelf.waterfallScrollService getFirstVisibleIndexPath:collectionView];
        
        NSInteger previousPosition = firstVisibleIndexPath.row;
        UICollectionViewCell *cellAtPreviousPosition = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousPosition inSection:0]];
        NSString *previousId = [((id<WaterfallItemCellProtocol>)cellAtPreviousPosition) itemId];
        CGFloat previousScrollOffset = collectionView.contentOffset.y;
        
        CGFloat previousCellOffset = cellAtPreviousPosition.frame.origin.y - previousScrollOffset;
        
        [UIView performWithoutAnimation:^{
            [collectionView performBatchUpdates:^{
                [collectionView deleteItemsAtIndexPaths:[change deletionsInSection:0]];
                [collectionView insertItemsAtIndexPaths:[change insertionsInSection:0]];
                [collectionView reloadItemsAtIndexPaths:[change modificationsInSection:0]];
            } completion:^(BOOL finished) {
                BOOL adjustResult = [weakSelf.waterfallScrollService adjustScroll:collectionView
                                                                         itemList:blockItemList
                                                                 previousPosition:previousPosition
                                                                       previousId:previousId
                                                               previousCellOffset:previousCellOffset];
                if(adjustResult && weakSelf.onScrollAfterUpdate) {
                    weakSelf.onScrollAfterUpdate(previousScrollOffset);
                }
            }];
        }];
    }];
}

@end

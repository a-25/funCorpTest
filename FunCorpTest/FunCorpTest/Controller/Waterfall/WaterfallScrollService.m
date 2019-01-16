//
//  WaterfallScrollService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallScrollService.h"

@interface WaterfallScrollService()

@property(nonatomic) NSInteger adjustScrollRows;

@end

@implementation WaterfallScrollService

-(BOOL)adjustScroll:(UICollectionView*)collectionView
         itemHeight:(CGFloat)itemHeight
            columns:(unsigned short) columns
previousScrollOffset:(CGFloat)previousScrollOffset
  previousIndexPath:(NSIndexPath*)previousIndexPath
 insertedIndexPaths:(NSArray<NSIndexPath *>*)insertedIndexPaths
  deletedIndexPaths:(NSArray<NSIndexPath *>*)deletedIndexPaths
{
    self.adjustScrollRows += [self getRowChange:previousIndexPath
                                     insertedIndexPaths:insertedIndexPaths
                                      deletedIndexPaths:deletedIndexPaths];
    int stringsToScroll = floor(self.adjustScrollRows / columns);
    if(stringsToScroll > 0) {
        CGFloat newOffset = MIN(previousScrollOffset + stringsToScroll * itemHeight, collectionView.contentSize.height);
        [collectionView setContentOffset:CGPointMake(0, newOffset) animated:NO];
        self.adjustScrollRows = 0;
        return true;
    }
    return false;
}

-(NSInteger)getRowChange:(NSIndexPath*)previousIndexPath insertedIndexPaths:(NSArray<NSIndexPath *>*)insertedIndexPaths deletedIndexPaths:(NSArray<NSIndexPath *>*)deletedIndexPaths
{
    __block NSUInteger insertedBeforeCount = 0;
    __block NSUInteger deletedBeforeCount = 0;
    [insertedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.row <= previousIndexPath.row) {
            insertedBeforeCount++;
        }
    }];
    [deletedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.row <= previousIndexPath.row) {
            deletedBeforeCount++;
        }
    }];
    NSInteger deltaRow = - deletedBeforeCount + insertedBeforeCount;
    return deltaRow;
}

@end

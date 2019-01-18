//
//  WaterfallScrollService.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallScrollService.h"

@implementation WaterfallScrollService

-(BOOL)adjustScroll:(UICollectionView*)collectionView
           itemList:(RLMResults<WaterfallItemObject *> *)itemList
   previousPosition:(NSInteger)previousPosition
         previousId:(NSString*)previousId
 previousCellOffset:(CGFloat) previousCellOffset
{
    //Find the new indexPath of element of previousId
    WaterfallItemObject *element = [[itemList objectsWhere:@"id == %@", previousId] firstObject];
    if(!element) {
        return NO;
    }
    NSUInteger currentIndex = [itemList indexOfObject:element];
    if(currentIndex == NSNotFound) {
        return NO;
    }
    if(currentIndex == previousPosition) {
        return NO;
    }
    
    //Extract the new cell
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UICollectionViewCell *currentCell = [collectionView cellForItemAtIndexPath:currentIndexPath];
    if(currentCell == nil) {
        //Default reaction if the cell is not present on the screen (this can be because of big insertion or deletion)
        [collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        return NO;
    }
    
    //Scroll
    CGFloat newContentOffset = MAX(0, MIN(currentCell.frame.origin.y - previousCellOffset, collectionView.contentSize.height));
    [collectionView setContentOffset:CGPointMake(0, newContentOffset) animated:NO];
    return YES;
}

-(NSIndexPath*)getFirstVisibleIndexPath:(UICollectionView*)collectionView
{
    NSArray<NSIndexPath *> *indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems;
    //The first visible row
    __block NSIndexPath *firstVisibleIndexPath;
    if([indexPathsForVisibleItems count] == 0) {
        firstVisibleIndexPath = nil;
    } else {
        firstVisibleIndexPath = [NSIndexPath indexPathForRow:NSIntegerMax inSection:0];
        [indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *visibleIndexPath, NSUInteger idx, BOOL *stop) {
            if (visibleIndexPath.row < firstVisibleIndexPath.row) {
                firstVisibleIndexPath = visibleIndexPath;
            }
        }];
    }
    return firstVisibleIndexPath;
}

@end

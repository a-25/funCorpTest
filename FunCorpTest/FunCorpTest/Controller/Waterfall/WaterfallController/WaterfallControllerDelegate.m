//
//  WaterfallControllerLayoutDelegate.m
//  FunCorpTest
//
//  Created by A-25 on 18/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallControllerDelegate.h"
#import "PictureViewCell.h"

@interface WaterfallControllerDelegate()

@property(nonatomic) CGFloat itemWidth;
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, weak) CHTCollectionViewWaterfallLayout *collectionViewLayout;
@property(nonatomic, strong) WaterfallControllerDataProvider *waterfallControllerDataProvider;

@end

@implementation WaterfallControllerDelegate

-(id)init
{
    @throw nil;
}

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView andCollectionViewLayout:(CHTCollectionViewWaterfallLayout*)collectionViewLayout andWaterfallControllerDataProvider:(WaterfallControllerDataProvider*)waterfallControllerDataProvider
{
    if (self = [super init]){
        _collectionView = collectionView;
        _waterfallControllerDataProvider = waterfallControllerDataProvider;
        _collectionViewLayout = collectionViewLayout;
        int margin = 10;
        _collectionViewLayout.minimumColumnSpacing = margin;
        _collectionViewLayout.minimumInteritemSpacing = margin;
        _collectionViewLayout.sectionInset = UIEdgeInsetsZero;
    }
    return self;
}

-(void)resetMinimalItemHeight
{
    _minimalItemHeight = CGFLOAT_MAX;
}

-(CHTCollectionViewWaterfallLayout*)waterfallLayout
{
    return (CHTCollectionViewWaterfallLayout*) self.collectionViewLayout;
}

-(void)setLayoutColumns:(unsigned short)columns
{
    [self resetMinimalItemHeight];
    [self waterfallLayout].columnCount = columns;
    [self.collectionView setNeedsLayout];
}

-(void)refreshLayout
{
    CHTCollectionViewWaterfallLayout *layout = [self waterfallLayout];
    unsigned short columns = layout.columnCount;
    UIEdgeInsets collectionSafeAreaInsets;
    
    if (@available(iOS 11.0, *)) {
        collectionSafeAreaInsets = self.collectionView.safeAreaInsets;
    } else {
        // Fallback on earlier versions
        collectionSafeAreaInsets = UIEdgeInsetsZero;
    }
    
    CGFloat marginsAndInsets = layout.sectionInset.left + layout.sectionInset.right + collectionSafeAreaInsets.left + collectionSafeAreaInsets.right + layout.minimumInteritemSpacing * (CGFloat)(columns - 1);
    self.itemWidth = floor((self.collectionView.bounds.size.width - marginsAndInsets) / (CGFloat)columns);
}

#pragma mark <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterfallItemObject *item = [self.waterfallControllerDataProvider.itemList objectAtIndex:indexPath.row];
    if(item.picture){
        CGFloat itemHeight = [PictureViewCell height:self.itemWidth forItem:item.picture];
        if(self.minimalItemHeight > itemHeight) {
            _minimalItemHeight = itemHeight;
        }
        return CGSizeMake(self.itemWidth, itemHeight);
    } else {
        return CGSizeMake(self.itemWidth, self.itemWidth);
    }
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemObject *item = [self.waterfallControllerDataProvider.itemList objectAtIndex:indexPath.row];
    if(item.picture){
        NSURL *url = [NSURL URLWithString:item.picture.pageUrl];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark <UIScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.onUserScrolled) {
        CGFloat currentPosition = scrollView.contentOffset.y;
        self.onUserScrolled(currentPosition);
    }
}

@end

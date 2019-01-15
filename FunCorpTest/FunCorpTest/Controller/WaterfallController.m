//
//  WaterfallController.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallController.h"
#import "DIService.h"
#import "WaterfallItemCellCollectionViewCell.h"

@interface WaterfallController ()

@end

@implementation WaterfallController

static NSString * const reuseIdentifier = @"WaterfallItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int margin = 10;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[WaterfallItemCellCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    UICollectionViewFlowLayout *layout = [self flowCollectionViewLayout];
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        // Fallback on earlier versions
    }
    
    
    // Do any additional setup after loading the view.
}

-(UICollectionViewFlowLayout*)flowCollectionViewLayout
{
    return (UICollectionViewFlowLayout*) self.collectionViewLayout;
}

-(unsigned short)columns
{
    return [DIService sharedInstance].colsCount;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *layout = [self flowCollectionViewLayout];
    unsigned short cellsPerRow = [self columns];
    UIEdgeInsets collectionSafeAreaInsets;
    
    if (@available(iOS 11.0, *)) {
        collectionSafeAreaInsets = self.collectionView.safeAreaInsets;
    } else {
        // Fallback on earlier versions
        collectionSafeAreaInsets = UIEdgeInsetsZero;
    }
    CGFloat marginsAndInsets = layout.sectionInset.left + layout.sectionInset.right + collectionSafeAreaInsets.left + collectionSafeAreaInsets.right + layout.minimumInteritemSpacing * (CGFloat)(cellsPerRow - 1);
    CGFloat itemWidth = floor((self.collectionView.bounds.size.width - marginsAndInsets) / (CGFloat)cellsPerRow);
    layout.itemSize =  CGSizeMake(itemWidth, floor(1.33 * itemWidth));
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView.collectionViewLayout invalidateLayout];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemCellCollectionViewCell *cell = (WaterfallItemCellCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"car"];
    [cell configure:image andTitle:[NSString stringWithFormat:@"Title %ld", indexPath.row + 1]];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

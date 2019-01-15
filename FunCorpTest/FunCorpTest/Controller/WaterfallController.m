//
//  WaterfallController.m
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallController.h"
#import "Realm/Realm.h"
#import "DIService.h"
#import "PlanService.h"
#import "WaterfallItemListService.h"
#import "DatabaseService.h"
#import "WaterfallItemObject.h"
#import "WaterfallItemCellCollectionViewCell.h"

@interface WaterfallController () {
    RLMResults* itemList;
}

@property(nonatomic, strong) PlanService *planService;
@property(nonatomic, strong) WaterfallItemListService *waterfallItemListService;
@property(nonatomic, strong) DatabaseService *databaseService;

@end

@implementation WaterfallController

static NSString * const reuseIdentifier = @"WaterfallItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _planService = [DIService sharedInstance].planService;
    _waterfallItemListService = [DIService sharedInstance].waterfallItemListService;
    _databaseService = [DIService sharedInstance].databaseService;
    
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
    [self refreshList];
    self.planService.currentPosition = 0;
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

-(void)refreshList
{
    self->itemList = [self.waterfallItemListService list:[self.databaseService getRealm]];
}

-(void)userScrolled:(NSInteger)row
{
    self.planService.currentPosition = row;
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
    return [self.waterfallItemListService listNumber:[self.databaseService getRealm]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemCellCollectionViewCell *cell = (WaterfallItemCellCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WaterfallItemObject *item = [self->itemList objectAtIndex:indexPath.row];
    UIImage *stub = [UIImage imageNamed:@"car"];
    [cell configure:stub andTitle:[NSString stringWithFormat:@"Tags: %@, views: %d", item.title, item.views]];
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

#pragma mark <UIScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    __block NSInteger xmax = 0;
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *visibleIndexPath, NSUInteger idx, BOOL *stop) {
        if (visibleIndexPath.row > xmax) {
            xmax = visibleIndexPath.row;
        }
    }];
    

//    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
//    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    [self userScrolled: xmax];
//    //scrolled to bottom end
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    if (bottomEdge >= scrollView.contentSize.height) {
//        [self scrolledToBottom];
//    }
}

//for (UICollectionViewCell *cell in [self.mainImageCollection visibleCells]) {
//    NSIndexPath *indexPath = [self.mainImageCollection indexPathForCell:cell];
//    NSLog(@"%@",indexPath);
//}

@end
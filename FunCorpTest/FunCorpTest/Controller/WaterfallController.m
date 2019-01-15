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
#import "DatabaseService.h"
#import "WaterfallItemObject.h"
#import "WaterfallItemCellCollectionViewCell.h"
#import "WaterfallItemPrefetcher.h"
#import "FetchService.h"

@interface WaterfallController () {
    WaterfallItemPrefetcher *prefetcher;
    RLMNotificationToken *notificationToken;
}

@property(nonatomic, strong) PlanService *planService;
@property(nonatomic, strong) DatabaseService *databaseService;
@property(nonatomic, strong) FetchService *fetchService;

@end

@implementation WaterfallController

static NSString * const reuseIdentifier = @"WaterfallItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _planService = [DIService sharedInstance].planService;
    _fetchService = [DIService sharedInstance].fetchService;
    _databaseService = [DIService sharedInstance].databaseService;
    
    if (@available(iOS 10.0, *)) {
//        self.collectionView.prefetchingEnabled = NO;
//        self->prefetcher = [[WaterfallItemPrefetcher alloc] initWithFetchService:_fetchService];
//        self.collectionView.prefetchDataSource = self->prefetcher;
    } else {
        // Fallback on earlier versions
    }
    
    int margin = 10;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UICollectionViewFlowLayout *layout = [self flowCollectionViewLayout];
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        // Fallback on earlier versions
    }
    
    self.planService.currentPosition = 0;
    [self bindUpdateNotifications];
}

- (void)dealloc {
    [self->notificationToken invalidate];
}

-(UICollectionViewFlowLayout*)flowCollectionViewLayout
{
    return (UICollectionViewFlowLayout*) self.collectionViewLayout;
}

-(void)bindUpdateNotifications
{
    __weak typeof(self) weakSelf = self;
    self->notificationToken = [self.fetchService.itemList addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
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
        
        NSLog(@"Delete: %@", [change deletionsInSection:0]);
        NSLog(@"Insert: %@", [change insertionsInSection:0]);
        NSLog(@"Update: %@", [change modificationsInSection:0]);
        
        [collectionView performBatchUpdates:^{
            [collectionView deleteItemsAtIndexPaths:[change deletionsInSection:0]];
            [collectionView insertItemsAtIndexPaths:[change insertionsInSection:0]];
            [collectionView reloadItemsAtIndexPaths:[change modificationsInSection:0]];
        } completion:^(BOOL finished) {
            
        }];
    }];
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
    return self.fetchService.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemCellCollectionViewCell *cell = (WaterfallItemCellCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WaterfallItemObject *item = [self.fetchService.itemList objectAtIndex:indexPath.row];
    [cell configure:item];
    if(![self.fetchService isDataFetchedForItem:item]) {
        [self.fetchService fetchAsync:item completion:^(WaterfallItemObject * _Nonnull item) {
            [cell configure:item];
        }];
    }
    return cell;
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
    WaterfallItemObject *item = [self.fetchService.itemList objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.pageUrl]
                                       options:@{}
                             completionHandler:nil];
}


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
    [self userScrolled: xmax];
//    //scrolled to bottom end
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    if (bottomEdge >= scrollView.contentSize.height) {
//        [self scrolledToBottom];
//    }
}

@end

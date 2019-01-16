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
#import "FetchService.h"
#import "SettingsController.h"
#import "PictureViewCell.h"
#import "AdsViewCell.h"

@interface WaterfallController () {
    RLMNotificationToken *notificationToken;
    CGFloat lastScrolledPosition;
    CGFloat itemHeight;
}

@property(nonatomic, strong) PlanService *planService;
@property(nonatomic, strong) DatabaseService *databaseService;
@property(nonatomic, strong) FetchService *fetchService;
@property(nonatomic, strong) AdsImportService *adsImportService;

@end

@implementation WaterfallController

static NSString * const reuseIdentifierPicture = @"PictureCell";
static NSString * const reuseIdentifierAds = @"AdsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _planService = [DIService sharedInstance].planService;
    _fetchService = [DIService sharedInstance].fetchService;
    _databaseService = [DIService sharedInstance].databaseService;
    _adsImportService = [DIService sharedInstance].adsImportService;
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierPicture];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AdsViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierAds];
    
    self.planService.currentPosition = 0;
    [self bindUpdateNotifications];
    [self.adsImportService start];
}

- (void)dealloc {
    [self.adsImportService stop];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsChanged:)
                                                 name:notificationSettingsChanged
                                               object:nil];
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
    self->itemHeight = floor(1.33 * itemWidth);
    layout.itemSize = CGSizeMake(itemWidth, self->itemHeight);
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

-(void)settingsChanged:(NSNotification*)notification
{
    [self.collectionView setNeedsLayout];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchService.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemObject *item = [self.fetchService.itemList objectAtIndex:indexPath.row];
    if(item.picture) {
        PictureViewCell *cell = (PictureViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifierPicture forIndexPath:indexPath];
        [cell configure:item.picture];
        if(![self.fetchService isDataFetchedForItem:item]) {
            [self.fetchService fetchAsync:item completion:^(WaterfallItemObject * _Nonnull item) {
                [cell configure:item.picture];
            }];
        }
        return cell;
    } else if (item.ads) {
        AdsViewCell *cell = (AdsViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifierAds forIndexPath:indexPath];
        [cell configure:item.ads];
        return cell;
    } else {
        return [UICollectionViewCell new];
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
    WaterfallItemObject *item = [self.fetchService.itemList objectAtIndex:indexPath.row];
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
    CGFloat currentPosition = scrollView.contentOffset.y;
    //only significant changes
    if(fabs(currentPosition - self->lastScrolledPosition) < self->itemHeight) {
        return;
    }
    self->lastScrolledPosition = currentPosition;
    
    __block NSInteger xmax = 0;
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *visibleIndexPath, NSUInteger idx, BOOL *stop) {
        if (visibleIndexPath.row > xmax) {
            xmax = visibleIndexPath.row;
        }
    }];
    [self userScrolled: xmax];
}

@end

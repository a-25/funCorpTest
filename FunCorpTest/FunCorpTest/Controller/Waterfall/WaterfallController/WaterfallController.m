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
#import "WaterfallItemListService.h"
#import "SettingsController.h"
#import "PictureViewCell.h"
#import "AdsViewCell.h"
#import "WaterfallScrollService.h"
#import "WaterfallItemCellProtocol.h"
#import "WaterfallControllerDataProvider.h"
#import "WaterfallControllerDelegate.h"

@interface WaterfallController () {
    CGFloat lastScrolledPosition;
}

@property(nonatomic, strong) PlanService *planService;
@property(nonatomic, strong) AdsImportService *adsImportService;
@property(nonatomic, strong) WaterfallControllerDataProvider *waterfallControllerDataProvider;
@property(nonatomic, strong) WaterfallControllerDelegate *waterfallControllerLayoutDelegate;

@end

@implementation WaterfallController

static NSString * const reuseIdentifierPicture = @"PictureCell";
static NSString * const reuseIdentifierAds = @"AdsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _planService = [DIService sharedInstance].planService;
    DatabaseService *databaseService = [DIService sharedInstance].databaseService;
    _adsImportService = [DIService sharedInstance].adsImportService;
    self.waterfallControllerDataProvider = [[WaterfallControllerDataProvider alloc] initWithCollectionView:self.collectionView
                                                                                 andWaterfallScrollService:[[WaterfallScrollService alloc] init]
                                                                                               andItemList:[[DIService sharedInstance].waterfallItemListService list:[databaseService getRealm]]];
    self.waterfallControllerLayoutDelegate = [[WaterfallControllerDelegate alloc] initWithCollectionView:self.collectionView
                                                                                       andCollectionViewLayout:(CHTCollectionViewWaterfallLayout*)self.collectionViewLayout
                                                                            andWaterfallControllerDataProvider:self.waterfallControllerDataProvider];
    [self.waterfallControllerLayoutDelegate resetMinimalItemHeight];
    self.collectionView.delegate = self.waterfallControllerLayoutDelegate;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        // Fallback on earlier versions
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierPicture];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AdsViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierAds];
    
    [self bindUpdateNotifications];
    self.planService.currentPosition = 0;
    [self.adsImportService start];
}

- (void)dealloc {
    [self.adsImportService stop];
}

-(void)bindUpdateNotifications
{
    __weak typeof(self) weakSelf = self;
    self.waterfallControllerDataProvider.onScrollAfterUpdate = ^void(CGFloat previousScrollOffset) {
        //adjust current vieweable element
        [weakSelf userScrolled:previousScrollOffset];
    };
    self.waterfallControllerLayoutDelegate.onUserScrolled = ^(CGFloat scrollPosition) {
        [weakSelf userScrolled: scrollPosition];
    };
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
    [self.waterfallControllerLayoutDelegate refreshLayout];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.waterfallControllerLayoutDelegate resetMinimalItemHeight];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)userScrolled:(CGFloat)currentScrollPosition
{
    //only significant changes
    if(fabs(currentScrollPosition - self->lastScrolledPosition) < self.waterfallControllerLayoutDelegate.minimalItemHeight) {
        return;
    }
    self->lastScrolledPosition = currentScrollPosition;
    
    __block NSInteger row = 0;
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *visibleIndexPath, NSUInteger idx, BOOL *stop) {
        if (visibleIndexPath.row > row) {
            row = visibleIndexPath.row;
        }
    }];
    self.planService.currentPosition = row;
}

-(void)settingsChanged:(NSNotification*)notification
{
    [self.waterfallControllerLayoutDelegate setLayoutColumns:[self columns]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.waterfallControllerDataProvider.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallItemObject *item = [self.waterfallControllerDataProvider.itemList objectAtIndex:indexPath.row];
    if(item.picture) {
        PictureViewCell *cell = (PictureViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifierPicture forIndexPath:indexPath];
        [cell configure:item.picture];
        cell.itemId = item.id;
        return cell;
    } else if (item.ads) {
        AdsViewCell *cell = (AdsViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:reuseIdentifierAds forIndexPath:indexPath];
        [cell configure:item.ads];
        cell.itemId = item.id;
        return cell;
    } else {
        return [UICollectionViewCell new];
    }
}

@end

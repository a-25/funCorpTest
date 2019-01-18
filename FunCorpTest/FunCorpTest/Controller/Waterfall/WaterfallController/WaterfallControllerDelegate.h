//
//  WaterfallControllerLayoutDelegate.h
//  FunCorpTest
//
//  Created by A-25 on 18/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h"
#import "WaterfallControllerDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallControllerDelegate : NSObject <CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate>

@property(nonatomic,readonly) CGFloat minimalItemHeight;
@property(nonatomic, copy, nullable) void (^onUserScrolled)(CGFloat scrollPosition);

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView andCollectionViewLayout:(CHTCollectionViewWaterfallLayout*)collectionViewLayout andWaterfallControllerDataProvider:(WaterfallControllerDataProvider*)waterfallControllerDataProvider NS_DESIGNATED_INITIALIZER;
-(void)resetMinimalItemHeight;
-(void)refreshLayout;
-(void)setLayoutColumns:(unsigned short)columns;

@end

NS_ASSUME_NONNULL_END

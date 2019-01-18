//
//  WaterfallScrollService.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Realm/Realm.h"
#import "WaterfallItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallScrollService : NSObject

-(BOOL)adjustScroll:(UICollectionView*)collectionView
           itemList:(RLMResults<WaterfallItemObject *> *)itemList
   previousPosition:(NSInteger)previousPosition
         previousId:(NSString*)previousId
 previousCellOffset:(CGFloat) previousCellOffset;

-(NSIndexPath*)getFirstVisibleIndexPath:(UICollectionView*)collectionView;

@end

NS_ASSUME_NONNULL_END

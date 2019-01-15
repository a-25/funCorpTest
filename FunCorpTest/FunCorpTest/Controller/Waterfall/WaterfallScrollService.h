//
//  WaterfallScrollService.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallScrollService : NSObject

-(BOOL)adjustScroll:(UICollectionView*)collectionView
         itemHeight:(CGFloat)itemHeight
            columns:(unsigned short) columns
previousScrollOffset:(CGFloat)previousScrollOffset
  previousIndexPath:(NSIndexPath*)previousIndexPath
 insertedIndexPaths:(NSArray<NSIndexPath *>*)insertedIndexPaths
  deletedIndexPaths:(NSArray<NSIndexPath *>*)deletedIndexPaths;

@end

NS_ASSUME_NONNULL_END

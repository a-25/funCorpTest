//
//  WaterfallControllerDatasource.h
//  FunCorpTest
//
//  Created by A-25 on 18/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/Realm.h"
#import "WaterfallItemObject.h"
#import "WaterfallScrollService.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallControllerDataProvider : NSObject

@property(nonatomic, strong, readonly) RLMResults<WaterfallItemObject*> *itemList;
@property(nonatomic, strong) WaterfallScrollService *waterfallScrollService;
@property(nonatomic, copy, nullable) void (^onScrollAfterUpdate)(CGFloat previousScrollOffset);

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView andWaterfallScrollService:(WaterfallScrollService*)waterfallScrollService andItemList:(RLMResults<WaterfallItemObject*> *)itemList NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

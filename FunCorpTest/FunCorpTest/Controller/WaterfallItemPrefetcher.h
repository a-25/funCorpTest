//
//  WaterfallItemPrefetcher.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchService.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemPrefetcher : NSObject <UICollectionViewDataSourcePrefetching>

@property(nonatomic, strong, readonly) FetchService *fetchService;
- (instancetype)initWithFetchService:(FetchService*)fetchService NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

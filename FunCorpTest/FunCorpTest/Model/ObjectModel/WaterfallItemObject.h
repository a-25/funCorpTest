//
//  WaterfallItemObject.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemObject : RLMObject

@property NSString *imageUrl;
@property NSString *cachedPath;
@property NSString *title;
@property int views;
@property NSDate *dateAdded;

@end

NS_ASSUME_NONNULL_END

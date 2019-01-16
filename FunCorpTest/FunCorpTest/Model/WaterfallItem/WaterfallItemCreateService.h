//
//  WaterfallItemCreateService.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterfallItemObject.h"
#import "PictureObject.h"
#import "AdsObject.h"
#import "Realm/Realm.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemCreateService : NSObject

-(WaterfallItemObject*)createWithPicture:(PictureObject*)picture inRealm:(RLMRealm*)realm;
-(WaterfallItemObject*)createWithAds:(AdsObject*)ads inRealm:(RLMRealm*)realm withSortOrder:(long)sortOrder;

@end

NS_ASSUME_NONNULL_END

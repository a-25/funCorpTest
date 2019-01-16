//
//  AdsCreateService.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsObject.h"
#import "Realm/Realm.h"
#import "WaterfallItemCreateService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdsCreateService : NSObject

@property(nonatomic, strong) WaterfallItemCreateService* waterfallItemCreateService;
-(AdsObject*)createInRealm:(RLMRealm*)realm;

@end

NS_ASSUME_NONNULL_END

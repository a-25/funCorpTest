//
//  WaterfallItemListService.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/Realm.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemListService : NSObject

-(RLMResults*)list:(RLMRealm*)realm;
-(unsigned long)listNumber:(RLMRealm*)realm;

@end

NS_ASSUME_NONNULL_END

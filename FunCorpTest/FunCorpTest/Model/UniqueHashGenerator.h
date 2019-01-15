//
//  UniqueHashGenerator.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniqueHashGenerator : NSObject

+(NSString*)generate:(nullable NSArray<NSString*>*)params;

@end

NS_ASSUME_NONNULL_END

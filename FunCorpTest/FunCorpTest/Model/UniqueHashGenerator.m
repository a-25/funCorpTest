//
//  UniqueHashGenerator.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "UniqueHashGenerator.h"
#import "MD5Digest/NSString+MD5.h"

@implementation UniqueHashGenerator

+(NSString*)generate:(nullable NSArray<NSString*>*)params
{
    NSString* joinedString = [NSString stringWithFormat:@"%@_%@",
                              [params componentsJoinedByString:@"_"],
                              [[NSUUID UUID] UUIDString]];
    return [joinedString MD5Digest];
}

@end

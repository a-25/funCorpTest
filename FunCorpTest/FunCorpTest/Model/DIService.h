//
//  DIService.h
//  FunCorpTest
//
//  Created by A-25 on 14/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIService : NSObject

+(DIService*)sharedInstance;

//@property(nonatomic,strong,readonly) CoreDataManager *coreDataManager;
@property(nonatomic) unsigned short colsCount;

@end

NS_ASSUME_NONNULL_END

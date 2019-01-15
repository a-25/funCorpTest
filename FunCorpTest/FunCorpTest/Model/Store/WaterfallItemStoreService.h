//
//  WaterfallItemStoreService.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseService.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemStoreService : NSObject

@property(nonatomic, strong) DatabaseService* databaseService;
@property(nonatomic, strong) NSString *apiKey;

-(void)importFromApi:(int)page andPerPage:(int)perPage;

@end

NS_ASSUME_NONNULL_END

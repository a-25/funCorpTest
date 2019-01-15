//
//  PictureStoreService.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseService.h"
#import "WaterfallItemCreateService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureStoreService : NSObject

@property(nonatomic, strong) DatabaseService* databaseService;
@property(nonatomic, strong) WaterfallItemCreateService* waterfallItemCreateService;
@property(nonatomic, strong) NSString *apiKey;
@property(nonatomic, strong) NSString *query;

-(void)importFromApi:(unsigned long)page andPerPage:(unsigned long)perPage;

@end

NS_ASSUME_NONNULL_END

//
//  PictureObject.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureObject : RLMObject

@property NSString *imageUrl;
@property NSString *pageUrl;
@property NSString *title;
@property int views;
@property int webformatWidth;
@property int webformatHeight;

@end

NS_ASSUME_NONNULL_END

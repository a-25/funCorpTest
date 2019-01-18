//
//  PictureViewCell.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureObject.h"
#import "WaterfallItemCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureViewCell : UICollectionViewCell <WaterfallItemCellProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property(nonatomic, strong) NSString *itemId;

-(void)configure:(PictureObject *)item;
+(CGFloat)height:(CGFloat)itemWidth forItem:(PictureObject *)item;

@end

NS_ASSUME_NONNULL_END

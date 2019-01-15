//
//  PictureViewCell.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)configure:(PictureObject *)item;

@end

NS_ASSUME_NONNULL_END

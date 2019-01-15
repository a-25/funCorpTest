//
//  WaterfallItemCellCollectionViewCell.h
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallItemCellCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)configure:(nullable UIImage*)picture andTitle:(nullable NSString*)title;

@end

NS_ASSUME_NONNULL_END

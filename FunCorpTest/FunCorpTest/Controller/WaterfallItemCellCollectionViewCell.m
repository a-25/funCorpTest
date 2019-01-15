//
//  WaterfallItemCellCollectionViewCell.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "WaterfallItemCellCollectionViewCell.h"

@implementation WaterfallItemCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configure:(nullable UIImage*)picture andTitle:(nullable NSString*)title
{
    self.pictureView.image = picture;
    self.titleLabel.text = title;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.pictureView.image = nil;
    self.titleLabel.text = nil;
}

@end

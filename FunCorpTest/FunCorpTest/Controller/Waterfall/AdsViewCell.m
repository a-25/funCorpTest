//
//  AdsViewCell.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "AdsViewCell.h"

@implementation AdsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configure:(AdsObject *)item
{
    self.titleLabel.text = item.title;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = nil;
}

@end

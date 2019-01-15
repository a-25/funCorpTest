//
//  PictureViewCell.m
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "PictureViewCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation PictureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configure:(PictureObject *)item
{
    UIImage *stub = [UIImage imageNamed:@"placeholder"];
    [self.pictureView setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:stub];
    self.titleLabel.text = [NSString stringWithFormat:@"Views: %d\ntags: %@", item.views, item.title];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.pictureView.image = nil;
    self.titleLabel.text = nil;
}

@end

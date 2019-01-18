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
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.pictureView.image = nil;
}

+(CGFloat)height:(CGFloat)itemWidth forItem:(PictureObject *)item
{
    CGFloat imageHeight = ceil(itemWidth * item.webformatHeight / item.webformatWidth);
    return imageHeight;
}

@end

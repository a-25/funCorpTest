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
    UIImage *stub = [UIImage imageNamed:@"car"];
    [self.pictureView setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:stub];
    
    
    //    NSString *localPath = item.cachedPath;
    //    if(localPath) {
    //        self.pictureView.image = [UIImage imageWithContentsOfFile: localPath];
    //    } else {
    //        UIImage *stub = [UIImage imageNamed:@"car"];
    //        self.pictureView.image = stub;
    //    }
    self.titleLabel.text = [NSString stringWithFormat:@"Tags: %@, views: %d", item.title, item.views];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.pictureView.image = nil;
    self.titleLabel.text = nil;
}

@end

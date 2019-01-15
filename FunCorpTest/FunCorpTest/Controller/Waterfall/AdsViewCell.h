//
//  AdsViewCell.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdsViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)configure:(AdsObject *)item;

@end

NS_ASSUME_NONNULL_END

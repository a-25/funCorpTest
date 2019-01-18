//
//  AdsViewCell.h
//  FunCorpTest
//
//  Created by A-25 on 16/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsObject.h"
#import "WaterfallItemCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdsViewCell : UICollectionViewCell <WaterfallItemCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) NSString *itemId;

-(void)configure:(AdsObject *)item;

@end

NS_ASSUME_NONNULL_END

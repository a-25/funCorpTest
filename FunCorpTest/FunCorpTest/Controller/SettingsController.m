//
//  SettingsController.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "SettingsController.h"
#import "DIService.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colCountSlider.value = [DIService sharedInstance].colsCount;
    [self refreshCountLabel];
}

- (IBAction)onDoneButtonTapped:(id)sender {
    [DIService sharedInstance].colsCount = [self colCount];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notificationSettingsChanged object:nil]];
    }];
}

- (IBAction)onSliderValueChanged:(id)sender {
    [self refreshCountLabel];
}

-(void)refreshCountLabel
{
    self.colCountLabel.text = [NSString stringWithFormat:@"Количество колонок: %d", [self colCount]];
}

-(unsigned int)colCount
{
    return (unsigned int) round(self.colCountSlider.value);
}

@end

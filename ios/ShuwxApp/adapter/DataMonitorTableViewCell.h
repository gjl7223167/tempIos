//
//  DataMonitorTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/7.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProLabel.h"

@interface DataMonitorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alarmValue;
@property (weak, nonatomic) IBOutlet UILabel *faultValue;
@property (weak, nonatomic) IBOutlet UILabel *descTitle;
@property (weak, nonatomic) IBOutlet UILabel *blValue;
@property (weak, nonatomic) IBOutlet UILabel *bjUnit;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *FiveView;

@property (weak, nonatomic) IBOutlet UIView *SixView;
@property (weak, nonatomic) IBOutlet ProLabel *xiakLabel;

@end


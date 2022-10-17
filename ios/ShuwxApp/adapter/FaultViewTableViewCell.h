//
//  FaultViewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/7.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface FaultViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *alarmName;
@property (weak, nonatomic) IBOutlet UILabel *alarmDate;
@property (weak, nonatomic) IBOutlet UILabel *alarmDesc;

@property (weak, nonatomic) IBOutlet ProBtn *okBtn;

@property (weak, nonatomic) IBOutlet UILabel *alarmTitle;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;


@end


//
//  DeviceManagerTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/21.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeviceManagerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *deviceFuze;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddr;
@property (weak, nonatomic) IBOutlet UIImageView *devicePic;
@property (weak, nonatomic) IBOutlet UILabel *deviceState;
@property (weak, nonatomic) IBOutlet UILabel *alarmSum;


@end

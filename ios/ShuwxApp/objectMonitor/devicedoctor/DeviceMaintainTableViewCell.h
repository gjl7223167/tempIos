//
//  DeviceMaintainTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2021/1/21.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceMaintainTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *byTime;
@property (strong, nonatomic) IBOutlet UILabel *byPerson;
@property (strong, nonatomic) IBOutlet UILabel *workTime;
@property (strong, nonatomic) IBOutlet UILabel *byContent;
@property (strong, nonatomic) IBOutlet UILabel *byRemark;


@end


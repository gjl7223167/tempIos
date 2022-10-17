//
//  UpcomingTaskTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingTaskTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *orderCode;
@property (strong, nonatomic) IBOutlet UIImageView *timeOutPic;

@property (weak, nonatomic) IBOutlet UIButton *wuxXunj;
@property (weak, nonatomic) IBOutlet UILabel *myTask;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
@property (weak, nonatomic) IBOutlet UILabel *taskdescire;
@property (strong, nonatomic) IBOutlet UILabel *dwvalue;

@end

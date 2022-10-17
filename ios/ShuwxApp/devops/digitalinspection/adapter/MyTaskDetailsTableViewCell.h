//
//  MyTaskDetailsTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTaskDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *statuView;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UILabel *positionValue;
@property (weak, nonatomic) IBOutlet UILabel *jiancmb;
@property (weak, nonatomic) IBOutlet UILabel *dianwmingc;
@property (weak, nonatomic) IBOutlet UILabel *weizxx;
@property (weak, nonatomic) IBOutlet UILabel *ddtype;

@property (strong, nonatomic) IBOutlet UILabel *taskTime;
@property (strong, nonatomic) IBOutlet UIView *wzxxView;


@end


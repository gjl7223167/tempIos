//
//  OkExperienceHistoryViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/10/9.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "BaseNavigationController.h"
#import "FaultOkViewController.h"


@interface OkExperienceHistoryViewController : MainViewController

@property (strong, nonatomic)  FaultOkViewController * oneVC;
@property (nonatomic,strong) NSString * msg_id;
@property (nonatomic,strong) NSString * create_time;
@property (nonatomic,strong) NSString * workStatus;

@end


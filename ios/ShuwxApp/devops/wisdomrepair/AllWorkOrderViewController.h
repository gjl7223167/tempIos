//
//  AllWorkOrderViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/15.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "AllWorkViewController.h"
#import <UMCommon/MobClick.h>
#import "WaitWorkViewController.h"
#import "WorkIngViewController.h"
#import "WorkEndViewController.h"

@interface AllWorkOrderViewController : MainViewController
@property (nonatomic,strong) NSMutableArray *childArr;
@end


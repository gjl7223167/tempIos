//
//  RepairTargetViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "RepairDeviceViewController.h"
#import "RepairPositionViewController.h"

@interface RepairTargetViewController : MainViewController
@property (nonatomic,strong) NSMutableArray *childArr;
@property (nonatomic,strong) NSString * curObjectId;
@end


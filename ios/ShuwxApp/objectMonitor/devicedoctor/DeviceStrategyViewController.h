//
//  DeviceStrategyViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "Node.h"
#import "TreeTableViewTwo.h"
#import "FreeControlViewController.h"
#import "StrategyDetailsViewController.h"


@interface DeviceStrategyViewController : MainViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong)NSString * object_id;
@property (nonatomic,strong) TreeTableViewTwo *tableview;
@end


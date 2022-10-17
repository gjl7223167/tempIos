//
//  AssignedDeptViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "Node.h"
#import "TreeTableViewThree.h"

@interface AssignedDeptViewController : MainViewController
@property (nonatomic,strong) NSString * plan_id;
@property (nonatomic,strong) NSString * job_id;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (strong, nonatomic) IBOutlet UIView *allView;


@end


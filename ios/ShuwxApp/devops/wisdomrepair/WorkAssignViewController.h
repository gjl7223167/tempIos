//
//  WorkAssignViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "Node.h"
#import "TreeTableViewThree.h"

@interface WorkAssignViewController : MainViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * order_id;
@end


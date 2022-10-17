//
//  RebootDeptViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "Node.h"
#import "TreeTableViewThree.h"


@interface RebootDeptViewController : MainViewController
@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end


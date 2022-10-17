//
//  OrderTypeViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "Node.h"
#import "TreeTableView.h"

@interface OrderTypeViewController : MainViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UIView *allView;



@end


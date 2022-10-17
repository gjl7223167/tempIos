//
//  SelectPersonViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "Node.h"
#import "TreeTableViewThree.h"

@interface SelectPersonViewController : MainViewController
@property (nonatomic,strong) NSString * set_id;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (nonatomic,strong) TreeTableViewThree *tableview;

@end


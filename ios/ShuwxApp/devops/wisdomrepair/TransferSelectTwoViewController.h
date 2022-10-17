//
//  TransferSelectTwoViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "Node.h"
#import "TreeTableViewThree.h"


@interface TransferSelectTwoViewController : MainViewController
@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *allDataSource;
@property (strong, nonatomic) IBOutlet UISearchBar *transferSearchBar;

@end


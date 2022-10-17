//
//  SearchDeviceViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/14.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "DeviceManagerTableViewCell.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ReportDeviceViewController.h"

@interface SearchDeviceViewController : MainViewController{
    UINib *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
    BOOL _hasMore;
@public int startRow;
@public int total;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * keysName;

@property (strong, nonatomic) IBOutlet UIView *allView;


@end


//
//  AllHistoryViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/11.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import <UMCommon/MobClick.h>

@interface AllHistoryViewController : MainViewController{
     UINib *_personNib;
        UINib * _emptyNib;
        UINib * _nodataNib;
        BOOL _hasMore;
    @public int startRow;
    @public int total;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end


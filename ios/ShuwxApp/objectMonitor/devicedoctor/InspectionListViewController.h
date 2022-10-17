//
//  InspectionListViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "InspectionListTableViewCell.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import <UMCommon/MobClick.h>
#import "InspectionListDetailsViewController.h"

@interface InspectionListViewController : MainViewController{
      UINib *_personNib;
        UINib * _emptyNib;
        UINib * _nodataNib;
        BOOL _hasMore;
    @public int startRow;
    @public int total;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString * object_id;

@end


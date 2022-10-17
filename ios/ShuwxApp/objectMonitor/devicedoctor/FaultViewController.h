//
//  FaultViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/7.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "FaultViewTableViewCell.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "DeviceRealEmpiricViewController.h"
#import "FaultOkViewController.h"
#import <UMCommon/MobClick.h>
#import "OkExperienceHistoryViewController.h"
#import "AlartDetailsViewController.h"

@interface FaultViewController : MainViewController{
    UINib *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
    BOOL _hasMore;
@public int startRow;
@public int total;
@public int refreshPosition;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * deviceId;
-(void)setRefresh;
-(void)updateTableViewItem:(id)message;
@end


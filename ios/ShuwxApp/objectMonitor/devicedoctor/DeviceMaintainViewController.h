//
//  DeviceMaintainViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/6.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "BaoyangEditDialog.h"
#import "BaoyangAddDialog.h"
#import "DeviceMaintainTableViewCell.h"

@interface DeviceMaintainViewController : MainViewController{
    UINib *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
    BOOL _hasMore;
@public int startRow;
@public int total;
}
@property (strong,nonatomic) NSString * deviceId;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)  NSString *userNikeName;

@property (weak, nonatomic) IBOutlet UIProgressView *myprogress;

@property (weak, nonatomic) IBOutlet UILabel *topCareTime;

@property (weak, nonatomic) IBOutlet UILabel *topRunWorkTime;
@property (weak, nonatomic) IBOutlet UILabel *topWoredTime;
@property (weak, nonatomic) IBOutlet UIButton *baoyBtn;
@property (strong,nonatomic) NSMutableDictionary * nsmuCare;
@property (strong,nonatomic)  NSString *firstByDate;

@end


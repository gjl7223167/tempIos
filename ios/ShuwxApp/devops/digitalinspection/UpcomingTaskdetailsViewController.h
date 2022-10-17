//
//  UpcomingTaskdetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"

#import "AssignedDeptViewController.h"
#import "MyTaskDetailsViewController.h"

#import "MyTaskTableHeaderFourView.h"

@interface UpcomingTaskdetailsViewController : MainViewController{
    UINib *_personNib;
          @public int total;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSString * job_id;
@property (weak, nonatomic) IBOutlet UIButton *zhipButton;
@property (nonatomic,strong) NSString * plan_id;
@property (weak, nonatomic) IBOutlet UIButton *lingqTask;

@property (nonatomic,strong) NSMutableDictionary * diction;

@property (weak, nonatomic)  UILabel *taskTime;
@property (weak, nonatomic)  UIButton *wuxuJx;
@property (weak, nonatomic)  UILabel *taskNumber;
@property (weak, nonatomic)  UILabel *taskName;
@property (weak, nonatomic)  UILabel *tsskPoint;
@property (weak, nonatomic)  UILabel *taskDescripe;


@property (nonatomic,strong) NSString * create_mode;
@property (nonatomic,strong) NSString * is_send;

@end


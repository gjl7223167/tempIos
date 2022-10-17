//
//  ShowTaskDetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/23.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "ProgressHUD.h"
#import "MJRefresh.h"

@interface ShowTaskDetailsViewController : MainViewController{
    UINib *_personNib;
                     @public int startRow;
                         @public int total;
      @public int temPosition;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary * cellIdentifierDic;

@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
@property (weak, nonatomic) IBOutlet UILabel *taskPerson;
@property (weak, nonatomic) IBOutlet UILabel *taskNumber;
@property (weak, nonatomic) IBOutlet UILabel *pointName;
@property (weak, nonatomic) IBOutlet UILabel *jianCmb;
@property (weak, nonatomic) IBOutlet UILabel *positionXx;
@property (weak, nonatomic) IBOutlet UILabel *ljSm;

@property (strong, nonatomic) NSString * job_id;
@property (strong, nonatomic) NSString * line_id;
@property (strong, nonatomic) NSString * plan_name;
@property (strong, nonatomic) NSString * is_sort;
@property (strong, nonatomic) NSString * create_time;
@property (strong, nonatomic) NSString * user_name;
@property (strong, nonatomic) NSString * lose_content;
@property (strong, nonatomic) NSString * valid_start;
@property (strong, nonatomic) NSString * valid_end;


@property (strong, nonatomic) IBOutlet UITextView *missLegend;
@property (strong, nonatomic) IBOutlet UIView *allView;

@property (strong, nonatomic) IBOutlet UILabel *taskType;
@property (strong, nonatomic) IBOutlet UIView *wzxxView;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end



//
//  OperateStepViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "OperateStepTableViewCell.h"

@interface OperateStepViewController : MainViewController{
    UINib *_personNib;
             UINib * _emptyNib;
             UINib * _nodataNib;
             BOOL _hasMore;
         @public int startRow;
         @public int total;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong,nonatomic) NSString * order_id;
@property (strong,nonatomic) NSString * content_id;
@property (strong, nonatomic) IBOutlet UITableView *uitableView;

@end


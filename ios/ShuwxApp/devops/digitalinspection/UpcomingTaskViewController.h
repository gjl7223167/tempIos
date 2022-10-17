//
//  UpcomingTaskViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "UpcomingTaskTableViewCell.h"
#import "UpcomingTaskdetailsViewController.h"

@interface UpcomingTaskViewController : MainViewController{
    UINib *_personNib;
          UINib * _emptyNib;
          UINib * _nodataNib;
          BOOL _hasMore;
      @public int startRow;
      @public int total;
    @public int refreshInt;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) NSMutableArray *allData;
@end



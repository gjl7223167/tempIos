//
//  MainWorkJournalViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "WorkJournalViewTableViewCell.h"

@interface MainWorkJournalViewController : MainViewController{
    UINib *_personNib;
              UINib * _emptyNib;
              UINib * _nodataNib;
              BOOL _hasMore;
          @public int startRow;
          @public int total;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * fixOrderFlowList;
@property (strong,nonatomic) NSString * order_id;

@end


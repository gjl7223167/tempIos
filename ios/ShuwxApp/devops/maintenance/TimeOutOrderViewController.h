//
//  TimeOutOrderViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MOFSPickerManager.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "AllWorkOrderViewController.h"
#import "OrderDetailsViewController.h"

@interface TimeOutOrderViewController : MainViewController{
    UINib *_personNib;
              UINib * _emptyNib;
              UINib * _nodataNib;
              BOOL _hasMore;
          @public int startRow;
          @public int total;
}
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end


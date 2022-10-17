//
//  WaitRepairViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/17.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MOFSPickerManager.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "AllWorkViewTableViewCell.h"
#import "TFDropDownMenuView.h"
#import "WorkDetailsViewController.h"

@interface MyordersIngViewController : MainViewController<TFDropDownMenuViewDelegate>{
    UINib *_personNib;
            UINib * _emptyNib;
            UINib * _nodataNib;
            BOOL _hasMore;
        @public int startRow;
        @public int total;
    @public int target_type;
    @public int date_type;
    @public int order_type;
@public int refreshInt;
}
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray * statusList;
@property (nonatomic,strong) NSMutableArray *orderTypeList;
@property (nonatomic,strong) NSMutableArray *allData;
@end


//
//  MyTaskEndViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MOFSPickerManager.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"

#import "MyTaskDetailsNoViewController.h"

@interface MyTaskEndViewController : MainViewController{
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
@property (nonatomic,weak) UIView *view1;
@property (nonatomic,strong) NSMutableArray *allData;

@end


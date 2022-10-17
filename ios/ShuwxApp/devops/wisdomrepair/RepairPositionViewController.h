//
//  RepairPositionViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import <UMCommon/MobClick.h>
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "RepairDeviceTableViewCell.h"
#import "ProBtn.h"


@interface RepairPositionViewController : MainViewController{
    UINib *_personNib;
                UINib * _emptyNib;
                UINib * _nodataNib;
@public int tmpPosition;
      @public int total;
@public long mposition;
}
@property (strong, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *selectData;
@property (strong, nonatomic) IBOutlet UIView *positionView;
@property (nonatomic,strong) UIButton * subBtm;

@end


//
//  RepairDeviceViewController.h
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


@interface RepairDeviceViewController : MainViewController{
    UINib *_personNib;
             UINib * _emptyNib;
             UINib * _nodataNib;
             BOOL _hasMore;
         @public int startRow;
         @public int total;
@public int tmpPosition;
}
@property (strong, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton * subBtm;
@property (nonatomic,strong) NSMutableDictionary * contentDic;
@property (nonatomic,strong) NSString * curObjectId;
@end


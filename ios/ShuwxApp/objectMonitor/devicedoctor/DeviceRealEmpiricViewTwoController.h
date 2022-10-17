//
//  DeviceRealEmpiricViewTwoController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/11/12.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "HisjyTableViewCell.h"
#import <UMCommon/MobClick.h>
#import "XLHModel.h"
#import "XLHLookMoreLabel.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"

@interface DeviceRealEmpiricViewTwoController : MainViewController{
    HisjyTableViewCell *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * msg_id;
@property (nonatomic,strong) NSString * create_time;
@end


//
//  DeviceRealEmpiricViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/6/24.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"


#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "FaultViewTableViewCell.h"

@interface DeviceRealEmpiricViewController : MainViewController{
    UINib *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
@public int refreshPosition;
@public int isFault;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * msg_id;
@property (nonatomic,strong) NSString * create_time;

@end



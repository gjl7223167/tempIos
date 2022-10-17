//
//  DeviceDataMonitorViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/6/4.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "DataMonitorTableViewCell.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import <UMCommon/MobClick.h>
#import "LowerControlViewController.h"
#import "LowerControlViewControllerTwo.h"
#import "LowerControlViewControllerThree.h"
#import "SocketRocket.h"

@interface DeviceDataMonitorViewController : MainViewController<SRWebSocketDelegate>{
    UINib *_personNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
    BOOL _hasMore;
@public int startRow;
@public int total;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong)NSString * projectId;
-(void)setRefresh:(NSString *)projectId;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (strong, nonatomic) SRWebSocket *socket;
@property (nonatomic,strong)NSString * pointKey;


@end

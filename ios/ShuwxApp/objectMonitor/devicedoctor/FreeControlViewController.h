//
//  FreeControlViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "StrategyTableViewCell.h"
#import "ProBtn.h"
#import "Utils.h"

@interface FreeControlViewController : MainViewController{
     UINib *_personNib;
        UINib * _emptyNib;
        UINib * _nodataNib;
        BOOL _hasMore;
    @public int startRow;
    @public int total;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString * selectId;
@property (strong, nonatomic) IBOutlet UIButton *pzButton;
@property (nonatomic,strong) NSMutableDictionary * myValue;

@end


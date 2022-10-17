//
//  AlarmTypeListViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "BqgzDialogTableViewCell.h"

typedef void (^ReturnValueBlockAlarmType) (NSMutableDictionary *strValue);
@interface AlarmTypeListViewController : MainViewController{
    UINib *_personNib;
            @public int total;
}
@property(nonatomic, copy) ReturnValueBlockAlarmType returnValueBlock;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *allData;
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


@end


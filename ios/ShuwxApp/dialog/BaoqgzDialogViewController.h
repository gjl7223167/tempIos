//
//  BaoqgzDialogViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "BqgzDialogTableViewCell.h"
typedef void (^ReturnValueBlockDic) (NSDictionary *strValue);

@interface BaoqgzDialogViewController : MainViewController{
    UINib *_personNib;
            @public int total;
}
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic, copy) ReturnValueBlockDic returnValueBlock;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end


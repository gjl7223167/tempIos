//
//  SolVeDialogViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "BqgzDialogTableViewCell.h"

typedef void (^ReturnValueBlock) (NSString *strValue);
@interface SolVeDialogViewController : MainViewController{
    UINib *_personNib;
            @public int total;
}

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end


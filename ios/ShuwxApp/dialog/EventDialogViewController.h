//
//  EventDialogViewController.h
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

typedef void (^EventReturnValueBlock) (NSMutableDictionary *strValue);
@interface EventDialogViewController : MainViewController{
    UINib *_personNib;
            @public int total;
}
@property(nonatomic, copy) EventReturnValueBlock returnValueBlock;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) NSString * curTitle;

@end


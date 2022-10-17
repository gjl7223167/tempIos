//
//  ReviewIngViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MOFSPickerManager.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"

#import "MissTaskDetailsViewController.h"


@interface ReviewIngViewController : MainViewController{
    UINib *_personNib;
                UINib * _emptyNib;
                UINib * _nodataNib;
                BOOL _hasMore;
            @public int startRow;
            @public int total;
}
@property (weak, nonatomic) IBOutlet UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end


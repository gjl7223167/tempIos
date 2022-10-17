//
//  CallReinforceViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "Node.h"
#import "TreeTableViewThree.h"
#import "CallReinforeToux.h"
#import "Masonry.h"


@interface CallReinforceViewController : MainViewController

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *selectList;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic)  UIView *viewlist;
@property (strong, nonatomic) IBOutlet UILabel *selectSum;
@property (strong, nonatomic) TreeTableViewThree *tableview;
@property (strong, nonatomic) IBOutlet UISearchBar *callSearchBar;
@property (strong, nonatomic) IBOutlet UIButton *callSubmit;

-(void)setUpdateDataList:(ProBtn *) mybtn;
@end


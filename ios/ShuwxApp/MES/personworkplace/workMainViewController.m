//
//  workMainViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/1.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "workMainViewController.h"
#import "BaseTableView.h"
#import "workTableViewCell.h"
#import "MJRefresh.h"
#import "UrlRequest.h"
#import <MJExtension.h>

#import "WorkTaskViewController.h"
#import "noNetWorkView.h"



@interface workMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;

@end

@implementation workMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:10];
    [self.view addSubview:self.myTableView];
    
    [self getWorkData];
//    [self setNoNetV];
}

-(void)setNoNetV
{
    self.noNetWorkV = [[noNetWorkView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.noNetWorkV.hidden = YES;
    self.noNetWorkV.reloadB = ^()
    {
        NSLog(@"reloadaaaaaa");
    };
    [self.view addSubview:self.noNetWorkV];

}

-(void)getWorkData
{
    //    {
    //        "dic_code" = "POM_woStatus_02";
    //        "dic_name" = "\U5f85\U5f00\U59cb";
    //        "dic_type" = "POM_woStatus";
    //        id = 805;
    //        "is_enable" = 1;
    //        "is_type" = 0;
    //        remark = x;
    //        sort = 1;
    //    }
    NSString *code = self.workDic[@"dic_code"];
    NSString *status = [NSString stringWithFormat:@"%@",self.workDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
//                            code,@"code",
                            status,@"status",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequest requestworkbenchappWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
//        {
//            propertyInfo = "<null>";
//            records =         (
//            );
//            total = 0;
//        }
        NSArray *arr = data[@"records"];
        if (result) {
            [self.dataArr addObjectsFromArray:arr];
            [self.myTableView reloadData];
        }
        else
        {
//            self.noNetWorkV.hidden = NO;
        }
        if(arr.count == 0 )
        {
            [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
            {
                [weakSelf.myTableView.mj_footer endRefreshing];
                [weakSelf.myTableView.mj_header endRefreshing];
            }

    }];
}

- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = 276;
        NSString *status = [NSString stringWithFormat:@"%@",self.workDic[@"id"]];
        if ([status integerValue] == 808) {
            _myTableView.rowHeight = 236;
        }
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
               //请求数据+刷新界面
            weakSelf.pageNum = 0;
            [weakSelf.dataArr removeAllObjects];
            [weakSelf getWorkData];
            
           }];
        
           self.myTableView.mj_header=header;
           
           //上拉刷新
           MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
               //调用刷新方法
               [weakSelf getWorkData];

           }];
           //footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
           footer.stateLabel.font = [UIFont systemFontOfSize:12];
           self.myTableView.mj_footer = footer;//添加上拉加载
           //    [self.myTableView.mj_header beginRefreshing];
           

    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    workTableViewCell *cell = [workTableViewCell cellWithTableView:tableView];
    cell.dataDic = self.dataArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkTaskViewController *task = [[WorkTaskViewController alloc] init];
    NSDictionary *dic = self.dataArr[indexPath.row];
    task.workOrderId = dic[@"id"];
    task.isDetail = YES;
    [self.navigationController pushViewController:task animated:YES];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

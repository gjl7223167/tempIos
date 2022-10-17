//
//  UnqualityHandleListViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/29.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityHandleListViewController.h"
#import "BaseTableView.h"
#import "MJRefresh.h"
#import "UrlRequest.h"
#import <MJExtension.h>
#import "noNetWorkView.h"

#import "UnqualityHandleListTableViewCell.h"
#import "UnqualityDetailViewController.h"

@interface UnqualityHandleListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;

@end

@implementation UnqualityHandleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;
    [self.view addSubview:self.myTableView];
    
    [self getWorkData];
//    [self setNoNetV];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return  _dataArr;
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
    
    NSString *status = [NSString stringWithFormat:@"%@",self.statusDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
//                            code,@"code",
                            status,@"status",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequest requestUnqualityHandleListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
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
        _myTableView.rowHeight = 216;
        if ([self.statusDic[@"dic_code"] isEqualToString:@"QOM_defective_product_disposal_03"]) {
            _myTableView.rowHeight = 216 - 40;
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
    UnqualityHandleListTableViewCell *cell = [UnqualityHandleListTableViewCell cellWithTableView:tableView];
    cell.dataDic = self.dataArr[indexPath.row];
    
    cell.deleteBtn.tag = indexPath.row + 100;
    cell.unqualityBtn.tag = indexPath.row + 100;
    
    [cell.deleteBtn addTarget:self action:@selector(DeleteItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.unqualityBtn addTarget:self action:@selector(UnqualityClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.statusDic[@"dic_code"] isEqualToString:@"QOM_defective_product_disposal_02"]) {
            cell.deleteBtn.hidden = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = self.dataArr[indexPath.row];
    UnqualityDetailViewController *vc = [[UnqualityDetailViewController alloc] init];
    vc.isDetail = YES;
    vc.unqualityDic = dic;
    vc.titleArr = self.titleArr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)DeleteItem:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self DeleteUnquality:index];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)DeleteUnquality:(NSInteger)index
{
    NSDictionary *dic = self.dataArr[index];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           dic[@"id"],@"id",
                           nil];
    
    [UrlRequest requestDeleteUnqualityWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            [self.dataArr removeObjectAtIndex:index];
            [self.myTableView reloadData];
        }
    }];
}

-(void)UnqualityClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataArr[index];
    UnqualityDetailViewController *vc = [[UnqualityDetailViewController alloc] init];
    vc.isDetail = NO;
    vc.unqualityDic = dic;
    vc.titleArr = self.titleArr;
    [self.navigationController pushViewController:vc animated:YES];
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

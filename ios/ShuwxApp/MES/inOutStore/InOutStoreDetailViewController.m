//
//  InOutStoreDetailViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/9.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InOutStoreDetailViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"
#import "MJRefresh.h"

#import "BillInfoTableViewCell.h"
#import "OutBillInfoTableViewCell.h"
#import "InMaterialInfoTableViewCell.h"
#import "OutMaterialInfoTableViewCell.h"

@interface InOutStoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *showArr;

@property (assign, nonatomic) int  pageNum;

@end

@implementation InOutStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    
    self.pageNum = 0;
    [self.view addSubview:self.myTableView];
    

    if (!self.dataDic) {
        [self StoreRoomManagerDetail:self.code];
    }
    [self StoreRoomDetailList];
}


-(void)setNavi
{
    if (self.isInStoreRoom) {
        self.title = @"入库详情";
    }else{
        self.title = @"出库详情";
    }

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
//    [leftButton setImage:[UIImage imageNamed:@"mes_right_black"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
//    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBarTintColor:[self colorWithHexString:@"#0089ff"]];

    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];

    
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArr;
}


- (NSMutableArray *)showArr
{
    if (!_showArr) {
        _showArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _showArr;
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
               //请求数据+刷新界面
            weakSelf.pageNum = 0;
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.showArr removeAllObjects];
            [weakSelf StoreRoomDetailList];
            
           }];
        
           self.myTableView.mj_header=header;
           
           //上拉刷新
           MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
               //调用刷新方法
               [weakSelf StoreRoomDetailList];

           }];
           //footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
           footer.stateLabel.font = [UIFont systemFontOfSize:12];
           self.myTableView.mj_footer = footer;//添加上拉加载
        
        UIView *footerV = [[UIView alloc] init];
        _myTableView.tableFooterView = footerV;
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return self.dataArr.count;
    }
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.isInStoreRoom) {
            BillInfoTableViewCell *cell = [BillInfoTableViewCell cellWithTableView:tableView];
            cell.dataDic = self.dataDic;
            return cell;
        }else{
            OutBillInfoTableViewCell *cell = [OutBillInfoTableViewCell cellWithTableView:tableView];
            cell.dataDic = self.dataDic;
            return cell;
        }
    }else if (indexPath.section == 1){
        int isUnfold = [self.showArr[indexPath.row] intValue];
        NSDictionary *dic = self.dataArr[indexPath.row];
        if (self.isInStoreRoom) {
            InMaterialInfoTableViewCell *cell = [InMaterialInfoTableViewCell cellWithTableView:tableView];
            [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.foldBtn.tag = 100 + indexPath.row;
            if (isUnfold == 1) {
                cell.foldBtn.selected = NO;
            }else
            {
                cell.foldBtn.selected = YES;
            }
            cell.serialNumL.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.dataArr.count];
            cell.dataDic = dic;
            return cell;
        }else{
            OutMaterialInfoTableViewCell *cell = [OutMaterialInfoTableViewCell cellWithTableView:tableView];
            [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.foldBtn.tag = 100 + indexPath.row;
            if (isUnfold == 1) {
                cell.foldBtn.selected = NO;
            }else
            {
                cell.foldBtn.selected = YES;
            }
            cell.serialNumL.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.dataArr.count];
            cell.dataDic = dic;
            return cell;
        }
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isInStoreRoom) {
            return 244;
        }else{
            return 293;
        }
    }
    if (indexPath.section == 1) {
        if (self.isInStoreRoom) {
            
            int isUnfold = [self.showArr[indexPath.row] intValue];
            if (isUnfold == 1) {
                return 357.0;
            }
            
            return 357.0 - 147.0;
        }else{
            int isUnfold = [self.showArr[indexPath.row] intValue];
            if (isUnfold == 1) {
                return 357.0;
            }
            
            return 357.0 - 146.0;
        }
    }
    return 50.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *infoStr = @"";

    if (section == 0) {
        infoStr = [NSString stringWithFormat:@"单据信息"];
        return [self getHeaderV:infoStr rightStr:nil rightSel:nil];

    }else if (section == 1)
    {
        infoStr = [NSString stringWithFormat:@"物料信息"];
        return [self getHeaderV:infoStr rightStr:nil rightSel:nil];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  55.0f;
}


-(UIView *)getHeaderV:(NSString *)leftStr rightStr:(NSString *)rightS rightSel:(NSString *)rightSel
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, 12, 4, 16)];
    view1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1];
    [bottomV addSubview:view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 20)];
    label.text = leftStr;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    
    return currentState;
}


-(void)FlodClick:(UIButton *)sender
{
    if (sender.selected) {
        self.showArr[sender.tag - 100] = @"1";
    }else{
        self.showArr[sender.tag - 100] = @"0";
    }
    [self.myTableView reloadData];
}


-(void)StoreRoomManagerDetail:(NSString *)codeStr
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    codeStr,@"code",
    @"",@"status",
    @"1",@"pageNum",
    @"10",@"pageSize",
    nil];
    WS(weakSelf)
    if (self.isInStoreRoom) {
        [UrlRequest requestInStoreMainListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                NSArray *records = data[@"records"];
                for (NSDictionary *dic in records) {
                    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
                    if ([weakSelf.workOrderId isEqualToString:uid]) {
                        weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:dic];
                    }
                }
            }
            [weakSelf.myTableView reloadData];
        }];
    }else
    {
        [UrlRequest requestOutStoreMainListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
           if (result) {
               NSArray *records = data[@"records"];
               for (NSDictionary *dic in records) {
                   NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
                   if ([weakSelf.workOrderId isEqualToString:uid]) {
                       weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:dic];
                   }
               }
               
           }
           [weakSelf.myTableView reloadData];
       }];
    }
}

-(void)StoreRoomDetailList
{
    self.pageNum++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];

    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"id",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    if (self.isInStoreRoom) {
        [UrlRequest requestInStoreDetailListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [weakSelf.myTableView.mj_footer endRefreshing];
            [weakSelf.myTableView.mj_header endRefreshing];
            if (result) {
                NSArray *records = data[@"records"];
                
                [weakSelf UpdateArray:records];

                NSInteger total = [data[@"total"] integerValue];
                if (total == weakSelf.dataArr.count) {
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else
            {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];

            }
            [self.myTableView reloadData];
        }];
    }else
    {
        [UrlRequest requestOutStoreDetailListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [weakSelf.myTableView.mj_footer endRefreshing];
            [weakSelf.myTableView.mj_header endRefreshing];
           if (result) {
               NSArray *records = data[@"records"];
               NSInteger total = [data[@"total"] integerValue];
               
               [weakSelf UpdateArray:records];
               
               if (total == weakSelf.dataArr.count) {
                   [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
               }
           }else
           {
               [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
           }
           [self.myTableView reloadData];
       }];
    }
}

-(void)UpdateArray:(NSArray *)records
{
    NSMutableArray *muArr = [[NSMutableArray alloc] initWithCapacity:records.count+1];
    for (int i = 0; i < records.count; i++) {
        [muArr addObject:@"1"];
    }
    [self.showArr addObjectsFromArray:muArr];
    [self.dataArr addObjectsFromArray:records];
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

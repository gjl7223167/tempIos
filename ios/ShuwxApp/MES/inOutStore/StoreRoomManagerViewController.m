//
//  StoreRoomManagerViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/26.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreRoomManagerViewController.h"
#import "WRNavigationBar.h"

#import "SearchViewController.h"
#import "UrlRequest.h"
#import "UrlRequestModel.h"
#import "BaseTableView.h"
#import "MJRefresh.h"
#import <MJExtension.h>
#import "noNetWorkView.h"

#import "propertyModel.h"
#import "NSObject+modelValue.h"

#import "StoreRequireListTableViewCell.h"

#import "InOutCreateStoreViewController.h"
#import "InOutStoreDetailViewController.h"

@interface StoreRoomManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellNum;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;
@property (strong, nonatomic) NSMutableArray *propertyArr;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@end

@implementation StoreRoomManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    self.pageNum = 0;
    cellNum = 0;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:5];
    
    [self.view addSubview:self.myTableView];
    [self requestModelandData];
}


-(void)setNavi
{
    if (self.isInStoreRoom) {
        self.navigationItem.title = @"库房入库管理";
    }else{
        self.navigationItem.title = @"库房出库管理";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // 设置导航栏颜色
//    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    [self wr_setNavBarBarTintColor:[self colorWithHexString:@"#0089ff"]];

    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];

    UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton1 setImage:[UIImage imageNamed:@"mes_add_wihte"] forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(addInOut) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton1 setFrame:CGRectMake(0,0,40,40)];
//    [rightButton1 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//    rightButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"sousuoone"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(sousuoClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton1, rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addInOut
{
    InOutCreateStoreViewController *vc = [[InOutCreateStoreViewController alloc] init];
    vc.isInStoreRoom = self.isInStoreRoom;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)sousuoClick
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchStoreRoomManager;
    vc.isInStore = self.isInStoreRoom;
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)requestModelandData
{
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getModelStyle:self.isInStoreRoom];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self.propertyArr ModelArrayHandleModelData];
        [self getWorkData];
    });
    
}

- (NSMutableArray *)propertyArr
{
    if (!_propertyArr) {
        _propertyArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _propertyArr;
}

-(void)getModelStyle:(BOOL)isInS
{
    NSString *code = @"outboundBill";
    if (isInS) {
        code = @"inboundBill";
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                code,@"code",
                                nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *dataD = data;
            NSArray *details = dataD[@"details"];
            NSArray *Arr = [propertyModel mj_objectArrayWithKeyValuesArray:details];
            [weakSelf.propertyArr addObjectsFromArray:Arr];

//            [weakSelf.propertyArr ModelShowArrFromshowPosition:1];
            
        }
        NSLog(@"ddddddd");
        dispatch_semaphore_signal(weakSelf.sema);
        
    }];
}


-(void)getWorkData
{
    NSString *code = @"outboundBill";
    if (self.isInStoreRoom) {
        code = @"inboundBill";
    }
    cellNum = self.propertyArr.count;

    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"",@"code",
                        nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            code,@"code",
                            map,@"map",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkListByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        [weakSelf.myTableView.mj_footer endRefreshing];
        [weakSelf.myTableView.mj_header endRefreshing];
        
        if (result) {
            
            NSInteger total = [data[@"total"] integerValue];
            NSArray *recordsArr = data[@"records"];
            NSDictionary *propertyInfoDic = data[@"propertyInfo"];
            if (!(propertyInfoDic&&propertyInfoDic.count != 0)) {
                propertyInfoDic = nil;
            }
            NSArray *arr = [weakSelf.propertyArr ModelArrayFromrecords:recordsArr propertyInfo:propertyInfoDic];
        
            [weakSelf.dataArr addObjectsFromArray:arr];
            if (total == weakSelf.dataArr.count) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.myTableView reloadData];
        }
        else
        {
//            self.noNetWorkV.hidden = NO;
            [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
        }

    }];
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.sectionHeaderHeight = 10;
//        _myTableView.rowHeight = 44;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001f)];
//        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf.propertyArr removeAllObjects];
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
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return cellNum;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    StoreRequireListTableViewCell *cell = [StoreRequireListTableViewCell cellWithTableView:tableView];
    NSDictionary *dic = self.dataArr[indexPath.section];
    propertyModel *model = self.propertyArr[indexPath.row];
    cell.propertyM = model;
    cell.valueDic = dic;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.section];
    
    NSLog(@"----%ld-----",(long)indexPath.section);
    InOutStoreDetailViewController *vc = [[InOutStoreDetailViewController alloc] init];
    vc.isInStoreRoom = self.isInStoreRoom;
    vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"workOrderId"]];
    vc.dataDic = nil;
    vc.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
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

//
//  StoreDetailRequireViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/19.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreDetailRequireViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"
#import "MJRefresh.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "StoreRequireTableViewCell.h"

#import "ApplyInStoreInfoViewController.h"
#import "ApplyOutStoreInfoViewController.h"

@interface StoreDetailRequireViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;

@end

@implementation StoreDetailRequireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;

    [self setNavi];
    [self.view addSubview:self.myTableView];
    
    [self getRequireDetailData];
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _dataArr;
}

-(void)getRequireDetailData
{
    self.pageNum++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];

    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"id",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequest requestRequireStoreDetailWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];

        if (result) {
            NSArray *records = data[@"records"];
            if (records&&records.count == 0) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.dataArr addObjectsFromArray:records];
                [weakSelf.myTableView reloadData];
            }
        }
    }];
}

-(void)setNavi
{
    if (self.isInStore) {
        self.title = @"入库需求明细";
    }else
    {
        self.title = @"出库需求明细";
    }
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
    [leftButton setImage:[UIImage imageNamed:@"mes_right_black"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];

    UIButton  *rightButton3  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton3 setImage:[UIImage imageNamed:@"mes_scan"] forState:UIControlStateNormal];
    [rightButton3 addTarget:self action:@selector(doScan) forControlEvents:UIControlEventTouchUpInside];
//    rightButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton3 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:rightButton3];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButton3];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)doScan
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openScanVCWithStyle:[StyleDIY ZhiFuBaoStyle]];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}


- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    MESScanViewController *vc = [MESScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.scanType = scanStoreDetailRequire;
    vc.myId = self.workOrderId;
    vc.ScanBackB = ^(NSString * _Nullable code) {
        //去创建界面
        [self pushApplyVc:code from:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArr removeAllObjects];

               //请求数据+刷新界面
            weakSelf.pageNum = 0;
            [weakSelf getRequireDetailData];
            
           }];
        
           self.myTableView.mj_header=header;
           
           //上拉刷新
           MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
               //调用刷新方法
               [weakSelf getRequireDetailData];

           }];
           //footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
           footer.stateLabel.font = [UIFont systemFontOfSize:12];
           self.myTableView.mj_footer = footer;//添加上拉加载
        
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
    
    StoreRequireTableViewCell *cell = [StoreRequireTableViewCell cellWithTableView:tableView];
    if (!self.isInStore) {
        cell.hadTitleL.text = @"已出数量";
    }
    cell.dataDic = self.dataArr[indexPath.row];
    cell.orderN.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.dataArr.count];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 281.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *mid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    [self pushApplyVc:mid from:NO];
}

-(void)pushApplyVc:(NSString *)mId from:(BOOL)fromScan
{
    if (self.isInStore) {
        ApplyInStoreInfoViewController *vc = [[ApplyInStoreInfoViewController alloc] init];
        vc.materialId = mId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ApplyOutStoreInfoViewController *vc = [[ApplyOutStoreInfoViewController alloc] init];
        vc.materialId = mId;
//        vc.fromScan = YES;
        vc.fromScan = fromScan;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

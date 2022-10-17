//
//  StoreRequireInfomationViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/19.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreRequireInfomationViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"
#import "MJRefresh.h"

#import "StoreRequireTableViewCell.h"
#import "StoreInfoTableViewCell.h"

@interface StoreRequireInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSArray *sectionOneArr;
@property (strong, nonatomic) NSArray *sectionTwoArr;
@property (strong, nonatomic) NSArray *sectionOneValueArr;
@property (strong, nonatomic) NSArray *sectionTwoValueArr;

@property (assign, nonatomic) int  pageNum;

@property (strong, nonatomic) dispatch_semaphore_t sema;
@property (strong,nonatomic) UIButton *toTopBtn;

@end

@implementation StoreRequireInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;

    [self setNavi];
    self.sectionOneArr = [NSArray arrayWithObjects:@"需求单编号",@"业务类型",@"关联单号",@"需求日期",@"创建人",@"创建时间", nil];
    if (self.isInStore) {
            self.sectionTwoArr = [NSArray arrayWithObjects:@"生产订单编号",@"工序名称", nil];
    }else
    {
        self.sectionTwoArr = [NSArray arrayWithObjects:@"生产订单编号",@"工序名称",@"需求位置", nil];
    }
    [self.view addSubview:self.myTableView];
    
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getRequireInfoData];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self getRequireDetailData];
    });
    
}

-(void)handleValueArr
{
    NSString *code = self.dataDic[@"code"];
    NSString *businessTypeName = self.dataDic[@"businessTypeName"];
    NSString *businessCode = self.dataDic[@"businessCode"];
    NSString *demandTime = self.dataDic[@"demandTime"];
    NSString *createUserName = self.dataDic[@"createUserName"];
    NSString *createTime = self.dataDic[@"createTime"];
    code = [self isToString:code];
    businessTypeName = [self isToString:businessTypeName];
    businessCode = [self isToString:businessCode];
    demandTime = [self isToString:demandTime];
    createUserName = [self isToString:createUserName];
    createTime = [self isToString:createTime];

    self.sectionOneValueArr = [NSArray arrayWithObjects:code?code:@"",businessTypeName?businessTypeName:@"",businessCode?businessCode:@"",demandTime?demandTime:@"",createUserName?createUserName:@"",createTime?createTime:@"", nil];
    
    NSString *productionOrder = self.dataDic[@"productionOrder"];
    NSString *segmentName = self.dataDic[@"segmentName"];
    productionOrder = [self isToString:productionOrder];
    productionOrder = [self isToString:productionOrder];
    
    if (self.isInStore) {
        self.sectionTwoValueArr = [NSArray arrayWithObjects:productionOrder?productionOrder:@"",segmentName?segmentName:@"", nil];

    }else
    {
        self.sectionTwoValueArr = [NSArray arrayWithObjects:productionOrder?productionOrder:@"",segmentName?segmentName:@"",@"暂无", nil];

    }

    //            {
    //                businessCode = "20201223-mes-123-abc-\U5f20-00002";
    //                businessId = 42;
    //                businessType = 873;
    //                businessTypeName = "\U76d8\U76c8\U5165\U5e93";
    //                code = "2-0030";
    //                createTime = "2020-12-23 09:28:19";
    //                createUser = 11;
    //                createUserName = mes;
    //                demandDetailsList = "<null>";
    //                id = 132;
    //                inOutBoundBillId = "<null>";
    //                isDelete = 0;
    //                outboundCode = "<null>";
    //                productionOrder = "1\U5f2020201223-12020122300000001";
    //                receiver = "<null>";
    //                remark = "<null>";
    //                segmentName = "\U9e4f";
    //                status = 854;
    //                statusName = "\U672a\U5f00\U59cb";
    //                stockList = "<null>";
    //                tenantId = 189;
    //                type = 1;
    //                updateTime = "2021-01-26 15:57:05";
    //                updateUser = "<null>";
    //            }
}

- (NSString *)isToString:(id)string {
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return string;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataArr;
}

- (UIButton *)toTopBtn
{
    if (!_toTopBtn) {
        _toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toTopBtn setBackgroundImage:[UIImage imageNamed:@"mes_backtotop"] forState:UIControlStateNormal];
//        _toTopBtn.backgroundColor = [UIColor redColor];
        _toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 64 - 17, self.view.frame.size.height - 45 - 64, 64, 64);
        [_toTopBtn addTarget:self action:@selector(ToTopClick) forControlEvents:UIControlEventTouchUpInside];
        _toTopBtn.hidden = YES;
        [self.view addSubview:_toTopBtn];
    }
    return _toTopBtn;
}

-(void)ToTopClick
{
    [self.myTableView setContentOffset:CGPointMake(0,0) animated:YES];
    self.toTopBtn.hidden = YES;
}

-(void)getRequireInfoData
{
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"id",
                                nil];
    WS(weakSelf)
    [UrlRequest requestRequireStoreInfomationWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:data];
            [weakSelf handleValueArr];
        }
        
        dispatch_semaphore_signal(weakSelf.sema);
    }];
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
        self.title = @"入库需求单详情";
    }
    else
    {
        self.title = @"出库需求单详情";
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

    
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kTopSafeAreaHeight + kStatusBarHeight + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
        _myTableView.sectionFooterHeight = 0.01;
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
        
        //上拉刷新
        WS(weakSelf)
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
    
    return 4;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }else if (section == 1)
    {
        return self.sectionOneArr.count;
    }else if (section == 2)
    {
        return self.sectionTwoArr.count;
    }else if (section == 3)
    {
//        if (self.dataArr.count) {
//            return 1;
//        }
        return self.dataArr.count;
    }
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(indexPath.section == 1)
    {

        StoreInfoTableViewCell *cell = [StoreInfoTableViewCell cellWithTableView:tableView];
        cell.TitleLabel.text = self.sectionOneArr[indexPath.row];
        if (self.sectionOneValueArr) {
            cell.SubTitleLabel.text = self.sectionOneValueArr[indexPath.row];
        }
        else{
            cell.SubTitleLabel.text = @"";
        }
        return cell;
    }else if (indexPath.section == 2)
    {
        StoreInfoTableViewCell *cell = [StoreInfoTableViewCell cellWithTableView:tableView];
        cell.TitleLabel.text = self.sectionTwoArr[indexPath.row];
        if (self.sectionTwoValueArr) {
            cell.SubTitleLabel.text = self.sectionTwoValueArr[indexPath.row];
        }
        else{
            cell.SubTitleLabel.text = @"";
        }
        return cell;
    }else if (indexPath.section == 3) {
        StoreRequireTableViewCell *cell = [StoreRequireTableViewCell cellWithTableView:tableView];
        if (!self.isInStore) {
            cell.hadTitleL.text = @"已出数量";
        }
        cell.dataDic = self.dataArr[indexPath.row];
        cell.orderN.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.dataArr.count];
        return cell;
    }else{
        StoreInfoTableViewCell *cell = [StoreInfoTableViewCell cellWithTableView:tableView];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3)
    {
        return 281;
    }
    return 50.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *imageN = nil;
        UIColor *color = [UIColor blackColor];
        
        if ([self.status isEqualToString:@"IOM_materialrequire_r_01"]||[self.status isEqualToString:@"IOM_materialrequire_c_01"]) {
            imageN = @"daizx_i";
            color = [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1];
        }else if ([self.status isEqualToString:@"IOM_materialrequire_r_02"]||[self.status isEqualToString:@"IOM_materialrequire_c_02"])
        {
            imageN = @"zant_i";
            color = [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1];
        }else if ([self.status isEqualToString:@"IOM_materialrequire_r_03"]||[self.status isEqualToString:@"IOM_materialrequire_c_03"])
        {
            imageN = @"yiwc_i";
            color = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1];
        }
        
        return [self gettopView:self.dataDic[@"statusName"] color:color image:imageN];

    }
    else
    {
        NSString *infoStr = @"";

        if (section == 1) {
            infoStr = [NSString stringWithFormat:@"基本信息"];
        }else if (section == 2)
        {
            infoStr = [NSString stringWithFormat:@"关联单信息"];
        }else if (section == 3)
        {
            infoStr = [NSString stringWithFormat:@"需求明细"];
        }
        return [self getHeaderV:infoStr rightStr:nil rightSel:nil];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  55.0f;
}


-(UIView *)gettopView:(NSString *)status color:(UIColor *)color image:(NSString *)imageN
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    if (!self.dataDic) {
        return currentState;
    }
    UIImageView *dotV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 15, 15)];
    dotV.image = [UIImage imageNamed:imageN];
    [bottomV addSubview:dotV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 80, 20)];
    label.text = @"当前状态：";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    UILabel *statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 80, 20)];
    statuslabel.text = status;
    statuslabel.font = [UIFont systemFontOfSize:14];
    
    statuslabel.textColor = color;
    [bottomV addSubview:statuslabel];
    
    return currentState;
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
    
    if (rightS) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightS forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(bottomV.frame.size.width - 60 - 16, 5, 60, 30);
        SEL sel = NSSelectorFromString(rightSel);
        [rightBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:rightBtn];
    }
    
    
    return currentState;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"aaaaaa%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 30) {
        self.toTopBtn.hidden = YES;
    }
    else
    {
        self.toTopBtn.hidden = NO;
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

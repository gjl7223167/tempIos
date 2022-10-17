//
//  ModelWorkTaskViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/11.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "ModelWorkTaskViewController.h"
#import "BaseTableView.h"
#import "workStyleOneTableViewCell.h"
#import "WRNavigationBar.h"
#import "noDataShowTableViewCell.h"
#import "commonShowTableViewCell.h"
#import "UrlRequest.h"

#import "workDetailViewController.h"
#import "materialDetailViewController.h"

#import "AnLightViewController.h"
#import "UrlRequestModel.h"
#import "NSObject+modelValue.h"

@interface ModelWorkTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasWork;
    BOOL hasMaterial;
    NSDictionary *baseDetailDic;
    NSDictionary *ModelDetailDic;
    NSInteger modelCount;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@end

@implementation ModelWorkTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    modelCount = self.propertyArr.count;
//    modelCount = 0;
    hasWork = NO;
    hasMaterial = NO;
    
    [self.view addSubview:self.myTableView];
    
    [self requestModelDetailData];

}

-(void)requestModelDetailData
{
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getDetailModelData];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self getDetailData];
    });
}

-(void)getDetailModelData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"id",
                            @"productionWorkOrder",@"code",
                                nil];
    WS(weakSelf)
    [UrlRequestModel requestDetailModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *dataD = [NSDictionary dictionaryWithDictionary:data];
            NSArray *dataArr = [NSArray arrayWithObject:dataD];
            
            dataArr = [weakSelf.propertyArr ModelArrayFromrecords:dataArr propertyInfo:nil];
            self->ModelDetailDic = dataArr[0];
            dispatch_semaphore_signal(weakSelf.sema);

//            [weakSelf.propertyArr ModelArrayFromrecords:dataArr completion:^(NSDictionary * _Nonnull dic) {
//                self->ModelDetailDic = dic;
//                dispatch_semaphore_signal(weakSelf.sema);
//            }];
            
        }
    }];
}

-(void)getDetailData
{
    NSString *orderid = [NSString stringWithFormat:@"%@",self.workOrderId];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                orderid,@"workOrderId",
                                nil];
    WS(weakSelf)
    [UrlRequest requestworkDetailWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            self->baseDetailDic = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadPageData];
            });
        }
    }];
}

-(void)reloadPageData
{
    [self statusChange];
    NSArray *materialConsumes = baseDetailDic[@"materialConsumes"];
    NSArray *reportRecords = baseDetailDic[@"reportRecords"];
    hasMaterial = NO;
    hasWork = NO;
    if (materialConsumes&&materialConsumes.count) {
        hasMaterial = YES;
    }
    if (reportRecords&&reportRecords.count) {
        hasWork = YES;
    }
    
    [self.myTableView reloadData];
    
}

- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64 + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
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
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (baseDetailDic) {
        return 4;
    }
    return 0;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 2 + modelCount;
    }
    else if (section == 2)
    {
        if (!hasWork) {
            return 1;
        }
        
        NSArray *reportRecords = baseDetailDic[@"reportRecords"];
        return reportRecords.count;
    }
    else if(section == 3)
    {
        if (!hasMaterial) {
            return 1;
        }
        NSArray *materialConsumes = baseDetailDic[@"materialConsumes"];
        return materialConsumes.count;
    }
    
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        if (!hasWork) {
           noDataShowTableViewCell *cell = [noDataShowTableViewCell cellWithTableView:tableView];
            return cell;
        }
        NSArray *reportRecords = baseDetailDic[@"reportRecords"];
        workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
        NSDictionary *dic = reportRecords[indexPath.row];
        cell.leftLabel.text = [NSString stringWithFormat:@"%@",dic[@"materialName"]];
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",dic[@"qty"]];
        return cell;
        
    }
    if (indexPath.section == 3) {
        if (!hasMaterial) {
            noDataShowTableViewCell *cell = [noDataShowTableViewCell cellWithTableView:tableView];
            return cell;
        }
        NSArray *materialConsumes = baseDetailDic[@"materialConsumes"];
        workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
        NSDictionary *dic = materialConsumes[indexPath.row];
        cell.leftLabel.text = [NSString stringWithFormat:@"%@",dic[@"materialName"]];
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",dic[@"qty"]];
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == modelCount) {
            commonShowTableViewCell *cell = [commonShowTableViewCell cellWithTableView:tableView];
            NSInteger total = [baseDetailDic[@"planQty"] integerValue];
            NSInteger part = [baseDetailDic[@"realQty"] integerValue];
            [cell.progresV setProgress:total part:part];
            return cell;
        }
        if (indexPath.row == modelCount + 1) {
            workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
            cell.leftLabel.text = @"操作人员";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",baseDetailDic[@"createUser"]];
        
            return cell;
        }
    }
    workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
    cell.propertyM = self.propertyArr[indexPath.row];
    cell.valueDic = ModelDetailDic;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        if (!hasWork) {
            return 110.0f;
        }
    }
    if (indexPath.section == 3) {
        if (!hasMaterial) {
            return 110.0f;
        }
    }
    if (indexPath.section == 1) {
    if (indexPath.row == modelCount) {
        return 120;
    }}
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
    if (section == 0) {
        
        //        [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1]  待执行
        //        [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1]  暂停
        //        [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1]  已完成
        //        [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1]  执行中
        NSString *imageN = @"";
        UIColor *color = [UIColor blackColor];
        int status = [baseDetailDic[@"status"] intValue];
        NSString *dic_code = [self getStatusCode:status];
        if ([dic_code isEqualToString:@"POM_woStatus_02"]) {
            imageN = @"daizx_i";
            color = [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1];
        }else if ([dic_code isEqualToString:@"POM_woStatus_03"])
        {
            imageN = @"zhixz_i";
            color = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
        }else if ([dic_code isEqualToString:@"POM_woStatus_04"])
        {
            imageN = @"zant_i";
            color = [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1];
        }else if ([dic_code isEqualToString:@"POM_woStatus_05"])
        {
            imageN = @"yiwc_i";
            color = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1];
        }else{
            
        }

        return [self gettopView:baseDetailDic[@"statusName"] color:color image:imageN];
    }
    else if (section == 1)
    {
        return [self getHeaderV:@"基本信息" rightStr:nil rightSel:nil];

    }
    else if (section == 2)
    {
        return [self getHeaderV:@"报工" rightStr:@"报工明细" rightSel:@"workDetail"];

    }
    else if (section == 3)
    {
        return [self getHeaderV:@"上料" rightStr:@"上料明细" rightSel:@"materialDetail"];

    }
    else
    {
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 20)];
        headview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headview;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return  55.0f;
    }
    else if (section == 1)
    {
        return  55.0f;
    }
    else if (section == 2)
    {
        return  55.0f;
    }
    else if (section == 3)
    {
        return  55.0f;
    }
    return  0.1f;
}

-(UIView *)gettopView:(NSString *)status color:(UIColor *)color image:(NSString *)imageN
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
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


-(void)setNavi
{
    if (self.isDetail) {
        self.title = @"生产任务详情";
    }
    else{
        self.title = @"生产任务报工";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
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
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];

}

-(void)statusChange
{
    int status = [baseDetailDic[@"status"] intValue];
    
    NSString *dic_code = [self getStatusCode:status];
    if ([dic_code isEqualToString:@"POM_woStatus_02"]) {
        [self doWorkShow];
    }else if ([dic_code isEqualToString:@"POM_woStatus_03"])
    {
        if (self.isDetail) {
            [self doRecordShow];
        }
        else
        {
            [self doStopShow];
        }
    }else if ([dic_code isEqualToString:@"POM_woStatus_04"])
    {
        [self doResumeShow];

    }else{
        
    }
}

-(NSString *)getStatusCode:(int)status
{
    NSString *dic_code = @"";
    for (NSDictionary *dic in self.allTitleArr) {
        NSInteger sts = [dic[@"id"] intValue];
        if (status == sts) {
            dic_code = dic[@"dic_code"];
        }
    }
    
    return dic_code;
}

-(void)doWorkShow
{
    UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setTitleColor:[UIColor colorWithRed:0 green:137.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton1  setTitle:@"开工" forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(doWork) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [rightButton1 setFrame:CGRectMake(0,0,40,40)];
//    [rightButton1 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//    rightButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    self.navigationItem.rightBarButtonItem = rightBarButton1;
}

-(void)doRecordShow
{
    UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
    [rightButton1  setTitle:@"记录" forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(doRecord) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [rightButton1 setFrame:CGRectMake(0,0,40,40)];
//    [rightButton1 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//    rightButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    self.navigationItem.rightBarButtonItem = rightBarButton1;
}

-(void)doStopShow
{
    self.title = @"生产任务报工";
    UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
    [rightButton1  setTitle:@"安灯" forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(doAnLight) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [rightButton1 setFrame:CGRectMake(0,0,40,40)];
    UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];

    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"mes_stop"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(doStop) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton1, rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}


-(void)doResumeShow
{
    self.isDetail = YES;
    self.title = @"生产任务详情";
//    mes_start
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"mes_start"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(doResume) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doWork
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.workOrderId,@"workOrderId",
                                nil];
    WS(weakSelf)
    [UrlRequest requestStartWorkWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            weakSelf.isDetail = NO;
            [weakSelf getDetailData];
        }
        
    }];
}

-(void)doRecord
{
    self.isDetail = NO;
    [self doStopShow];
}

-(void)doAnLight
{
    AnLightViewController *vc = [[AnLightViewController alloc] init];
    vc.workOrderId = self.workOrderId;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)doStop
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.workOrderId,@"workOrderId",
                            @"1",@"type",
                                nil];
    WS(weakSelf)
    [UrlRequest requestStopAndResumeWorkWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf getDetailData];
        }
    }];
}

-(void)doResume
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.workOrderId,@"workOrderId",
                            @"2",@"type",
                                nil];
    WS(weakSelf)
    [UrlRequest requestStopAndResumeWorkWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            weakSelf.isDetail = NO;
            [weakSelf getDetailData];
        }
    }];
}

-(void)workDetail
{
    workDetailViewController *vc = [[workDetailViewController alloc] init];
    vc.workOrderId = self.workOrderId;
    vc.isDetail = self.isDetail;
    vc.materialName = baseDetailDic[@"materialName"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)materialDetail
{
    materialDetailViewController *vc = [[materialDetailViewController alloc] init];
    vc.workOrderId = self.workOrderId;
    vc.isDetail = self.isDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

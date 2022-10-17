//
//  WorkTaskViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WorkTaskViewController.h"
#import "BaseTableView.h"
#import "workStyleOneTableViewCell.h"
#import "WRNavigationBar.h"
#import "noDataShowTableViewCell.h"
#import "commonShowTableViewCell.h"
#import "workDetailViewController.h"
#import "UrlRequest.h"
#import "AnLightViewController.h"

@interface WorkTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasWork;
    BOOL hasMaterial;
    NSDictionary *baseDetailDic;
}
@property (strong, nonatomic) BaseTableView *myTableView;

@end

@implementation WorkTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    hasWork = NO;
    hasMaterial = NO;
    
    [self.view addSubview:self.myTableView];
    
    [self getDetailData];

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
//            {
//                code = "20201125-mes-123-abc-null-00003";
//                createUser = mes;
//                id = 3;
//                materialCode = wl001;
//                materialConsumes =     (
//                            {
//                        materialName = "\U94a2\U677fT4.75";
//                        qty = 1;
//                    },
//                            {
//                        materialName = "\U7269\U6599003";
//                        qty = 1;
//                    },
//                            {
//                        materialName = "\U7269\U6599003";
//                        qty = 2;
//                    }
//                );
//                materialId = 11;
//                materialName = "\U7269\U6599001";
//                orderCode = "\U7269\U6599001null2020112500000002";
//                planEndTime = "2020-11-26 00:00:00";
//                planQty = 100;
//                planStartTime = "2020-11-25 00:00:00";
//                realEndTime = "<null>";
//                realQty = 4;
//                realStartTime = "2020-11-25 11:30:44";
//                reportRecords =     (
//                            {
//                        materialName = "\U7269\U6599001";
//                        qty = 2;
//                    },
//                            {
//                        materialName = "\U7269\U6599001";
//                        qty = 1;
//                    },
//                            {
//                        materialName = "\U7269\U6599001";
//                        qty = 1;
//                    }
//                );
//                segmentCode = 001;
//                segmentId = 2;
//                segmentName = "\U9524";
//                status = 806;
//                statusName = "\U4f5c\U4e1a\U4e2d";
//                unitName = "<null>";
//            }
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
        return 10;
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
        if (indexPath.row == 8) {
            commonShowTableViewCell *cell = [commonShowTableViewCell cellWithTableView:tableView];
            NSInteger total = [baseDetailDic[@"planQty"] integerValue];
            NSInteger part = [baseDetailDic[@"realQty"] integerValue];
            [cell.progresV setProgress:total part:part];
            return cell;
        }
        if (indexPath.row == 9) {
            workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
            cell.leftLabel.text = @"操作人员";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",baseDetailDic[@"createUser"]];
        
            return cell;
        }
    }
    workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
    
    
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
    if (indexPath.row == 8) {
        return 120;
    }}
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
    if (section == 0) {
        //{
        //    code = "20201125-mes-123-abc-null-00002";
        //    id = 2;
        //    materialCode = wl001;
        //    materialId = 11;
        //    materialName = "\U7269\U6599001";
        //    orderCode = "\U7269\U6599001null2020112500000001";
        //    planEndTime = "2020-11-26 00:00:00";
        //    planQty = 100;
        //    planStartTime = "2020-11-25 00:00:00";
        //    realEndTime = "<null>";
        //    realStartTime = "2020-11-25 15:40:04";
        //    segmentCode = 002;
        //    segmentId = 3;
        //    segmentName = "\U6253";
        //    status = 806;
        //    statusName = "\U4f5c\U4e1a\U4e2d";
        //}
        //        [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1]  待执行
        //        [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1]  暂停
        //        [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1]  已完成
        //        [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1]  执行中
        NSString *imageN = @"";
        UIColor *color = [UIColor blackColor];
        switch ([baseDetailDic[@"status"] intValue]) {
            case 805:
                {
                    imageN = @"daizx_i";
                    color = [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1];
                }
                break;
            case 806:
                {
                    imageN = @"zhixz_i";
                    color = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
                }
                break;
            case 807:
                {
                    imageN = @"zant_i";
                    color = [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1];
                }
                break;
            case 808:
                {
                    imageN = @"yiwc_i";
                    color = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1];
                }
                break;
                
            default:
                break;
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

-(void)workDetail
{
    workDetailViewController *vc = [[workDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)materialDetail
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];

}

-(void)statusChange
{
    
    switch ([baseDetailDic[@"status"] intValue]) {
        case 805:
            {
                [self doWorkShow];
            }
            break;
        case 806:
            {
                if (self.isDetail) {
                    [self doRecordShow];
                }
                else
                {
                    [self doStopShow];
                }
            }
            break;
        case 807:
            {
                [self doResumeShow];
            }
            break;
        case 808:
            {}
            break;
            
        default:
            break;
    }
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
            [weakSelf getDetailData];
        }
        
    }];
}

-(void)doRecord
{
    [self doStopShow];
}

-(void)doAnLight
{
    AnLightViewController *vc = [[AnLightViewController alloc] init];
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
            [weakSelf getDetailData];
        }
    }];
}




@end

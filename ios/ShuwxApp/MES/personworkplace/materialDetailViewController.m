//
//  materialDetailViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/16.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "materialDetailViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "workStyleOneTableViewCell.h"
#import "materialCreateViewController.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"
#import "NoDataView.h"
@interface materialDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UIView *NoDeatailV;
@property (strong, nonatomic) NSArray *propertyArr;

@end

@implementation materialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    [self.view addSubview:self.myTableView];
    [self noWorkDetailShow];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getListData];

}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _dataArr;
}

- (NSArray *)propertyArr
{
    if (!_propertyArr) {
        
        _propertyArr = [NSArray arrayWithObjects:@{@"materialName":@"物料名称"},
                                                @{@"batchCode":@"批次号"},
                                                @{@"sequenceCode":@"序列号"},
                                                @{@"qty":@"数量"},
                                                nil];
    }
    return _propertyArr;
}

-(void)getListData
{
    NSString *orderid = [NSString stringWithFormat:@"%@",self.workOrderId];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                orderid,@"workOrderId",
                                nil];
    WS(weakSelf)
    [UrlRequest requestMaterialListDetailWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:[weakSelf handleOriginalData:data]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dataArr.count == 0) {
                    weakSelf.NoDeatailV.hidden = NO;
                }
                else
                {
                    [weakSelf.myTableView reloadData];
                }
            });
            
        }
        else
        {
            
        }
    }];
}

-(void)setNavi
{
    self.title = @"上料明细";
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

    if (!self.isDetail) {
        [self rightBarItem];
    }
}

-(void)rightBarItem
{
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"mes_add"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
//    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    UIButton  *rightButton3  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton3 setImage:[UIImage imageNamed:@"mes_scan"] forState:UIControlStateNormal];
    [rightButton3 addTarget:self action:@selector(doScan) forControlEvents:UIControlEventTouchUpInside];
//    rightButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton3 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:rightButton3];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButton2,rightBarButton3];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doAdd
{
    materialCreateViewController *vc = [[materialCreateViewController alloc] init];
    vc.workOrderId = self.workOrderId;
    [self.navigationController pushViewController:vc animated:YES];
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
    WS(weakSelf)
    MESScanViewController * vc = [MESScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.scanType = scanMaterialDetail;
    vc.ScanBackB = ^(NSDictionary * _Nullable data) {
        //去创建界面
        materialCreateViewController *vc = [[materialCreateViewController alloc] init];
        vc.workOrderId = self.workOrderId;
        vc.materialDic = data;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)noWorkDetailShow
{
    NoDataView *view = [[NoDataView alloc] initWithFrame:CGRectMake(0, 10 + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view initSubViewsWithTip:@"暂无上料信息，请添加"];
    self.NoDeatailV = view;
    
    self.NoDeatailV.hidden = YES;
    
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
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.propertyArr.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
    cell.titleDic = self.propertyArr[indexPath.row];
    cell.rightValueDic = self.dataArr[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *infoStr = [NSString stringWithFormat:@"信息%ld",section+1];
    return [self getHeaderV:infoStr rightStr:nil rightSel:nil];
    
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


-(NSArray *)handleOriginalData:(id)data
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:6];
    if ([data isKindOfClass:[NSArray class]]) {
        [arr addObjectsFromArray:data];
    }
    return arr.copy;
}

@end

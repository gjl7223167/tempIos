//
//  ApplyOutStoreInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/28.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "ApplyOutStoreInfoViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "StoreInfoTableViewCell.h"
#import "UnfoldStoreRequireTableViewCell.h"
#import "BatchOutStoreTableViewCell.h"
#import "TypeFourTableViewCell.h"

#import "RemarksView.h"

#import "MaterialReceiverViewController.h"
#import "BottomListShowView.h"


@interface ApplyOutStoreInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) BOOL isUnfold;

@property (strong,nonatomic) RemarksView *remarksV;
@property (strong,nonatomic) UIView *bottomTotalV;

@property (strong,nonatomic) UIButton *submitBtn;
@property (nonatomic,copy)NSString *markStr;

@property (strong,nonatomic) UILabel *totalLabel;

@property (strong,nonatomic) NSString *recieverId;
@property (strong,nonatomic) NSString *totalN;

@property (strong,nonatomic) BottomListShowView *listV;
@end

@implementation ApplyOutStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    self.isUnfold = YES;
    self.recieverId = @"";
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.bottomTotalV];
    
    [self getApplyOutStoreData];
}

-(void)getApplyOutStoreData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.materialId,@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestOutStoreRequireInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {

        if (result) {
            weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:data];
            [self.dataArr addObjectsFromArray:[NSArray arrayWithArray:weakSelf.dataDic[@"list"]]];
            [self updateTotalView];
            [weakSelf.myTableView reloadData];
            
        }
    }];
}

-(void)setNavi
{
    self.title = @"填写出库信息";

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

-(void)updateTotalView
{
    NSInteger mTotal = 0;
    for (NSDictionary *dic in self.dataArr) {
        mTotal += [dic[@"qty"] integerValue];
    }
    self.totalN = [NSString stringWithFormat:@"%ld",mTotal];
    self.totalLabel.text = [NSString stringWithFormat:@"%ld",mTotal];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (RemarksView *)remarksV
{
    if (!_remarksV) {
        _remarksV = [[RemarksView alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 100)];
//        _remarksV.backgroundColor = [UIColor redColor];
        self.markStr = @"";
        WS(weakSelf)
        _remarksV.contentTV.infoBlock = ^(NSString *text, CGSize textViewSize) {
//            NSLog(@"当前文字: %@   当前高度:%lf",text,textViewSize.height);
            weakSelf.markStr = text;
        };
    }
    return _remarksV;
}

- (UIView *)bottomTotalV
{
    if (!_bottomTotalV) {
        _bottomTotalV = [UIView new];
        _bottomTotalV.backgroundColor = [UIColor whiteColor];
        _bottomTotalV.frame = CGRectMake(0, self.view.frame.size.height - 73 - kBottomSafeAreaHeight, SCREEN_WIDTH, 73);
        
        UILabel *label1= [UILabel new];
        label1.text = @"总计:";
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [UIColor blackColor];
        label1.frame = CGRectMake(16, 24, 50, 25);
        [_bottomTotalV addSubview:label1];
        
        UILabel *label2 = [UILabel new];
        label2.text = @"0";
        label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = [UIColor blackColor];
        label2.frame = CGRectMake(70, 24, 120, 25);
        [_bottomTotalV addSubview:label2];
        self.totalLabel = label2;
        
        [_bottomTotalV addSubview:self.submitBtn];
    }
    return _bottomTotalV;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(SCREEN_WIDTH - 16 - 170, 12, 170, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kTopSafeAreaHeight + kStatusBarHeight + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight - 73) style:UITableViewStyleGrouped];
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
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 126);
        [footerV addSubview:self.remarksV];
        _myTableView.tableFooterView = footerV;
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.dataDic) {
            return 3;
        }
    }else if (section == 1)
    {
        if (self.dataDic) {
            return 1 + self.dataArr.count;
        }
    }
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        StoreInfoTableViewCell *cell = [StoreInfoTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.TitleLabel.text = @"业务类型";
            cell.SubTitleLabel.text = self.dataDic[@"businessType"];
        }else if (indexPath.row == 1){
            cell.TitleLabel.text = @"关联单号";
            cell.SubTitleLabel.text = self.dataDic[@"businessCode"];
        }else if(indexPath.row == 2){
            TypeFourTableViewCell *viewCell = [TypeFourTableViewCell cellWithTableView:tableView];
            viewCell.TitleLabel.text = @"收料人";
            [viewCell.rightBtn addTarget:self action:@selector(RecieverChoose) forControlEvents:UIControlEventTouchUpInside];

            return viewCell;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UnfoldStoreRequireTableViewCell *cell = [UnfoldStoreRequireTableViewCell cellWithTableView:tableView];
            [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.dataDic = self.dataDic;
            cell.HadTitleL.text = @"已出数量";
            return cell;
        }else{
            
            BatchOutStoreTableViewCell *cell = [BatchOutStoreTableViewCell cellWithTableView:tableView];
            cell.fromScan = self.fromScan;
            cell.dataDic = self.dataArr[indexPath.row - 1];
            cell.OutStoreLocationScanBtn.tag = 100 + indexPath.row;
            cell.rightBtn.tag = 100 + indexPath.row;
            [cell.OutStoreLocationScanBtn addTarget:self action:@selector(OutStoreLocationScan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightBtn addTarget:self action:@selector(OutStoreLocationChoose:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
        }
    }
    
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.isUnfold) {
                return 292.0;
            }
            return 80.0;
        }else
        {
            return 153.0;
        }
    }
    return 50.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *infoStr = @"";

    if (section == 0) {
        infoStr = [NSString stringWithFormat:@"单据信息"];
    }else if (section == 1)
    {
        infoStr = [NSString stringWithFormat:@"物料信息"];
    }
    return [self getHeaderV:infoStr rightStr:nil rightSel:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  55.0f;
}


-(UIView *)getHeaderV:(NSString *)leftStr rightStr:(NSString *)rightS rightSel:(NSString *)rightSel
{
//    mes_volume 14*12
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
    
    if (!self.fromScan&&[leftStr isEqualToString:@"物料信息"]) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"mes_volume"];
        imgV.frame = CGRectMake(105, 14, 14, 12);
        [bottomV addSubview:imgV];
        
        UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 200, 20)];
        textL.text = @"已按先进先出为您推荐了出库位置";
        textL.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        textL.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [bottomV addSubview:textL];
    }
    
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

-(void)FlodClick:(UIButton *)sender
{
    self.isUnfold = sender.selected;
    sender.selected = !sender.selected;
    [self.myTableView reloadData];
}

-(void)RecieverChoose
{
    MaterialReceiverViewController *vc = [[MaterialReceiverViewController alloc] init];
    vc.RecieverBack = ^(NSDictionary *dic) {
        //收料人
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
        TypeFourTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
        cell.rightTF.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.recieverId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)OutStoreLocationScan:(UIButton *)sender
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openScanVCWithStyle:[StyleDIY ZhiFuBaoStyle] tag:sender.tag - 100];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style tag:(NSInteger)tag
{
    NSDictionary *dic = self.dataArr[tag - 1];
    NSMutableDictionary *mydic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mydic setValue:self.dataDic[@"materialId"] forKey:@"materialId"];

    MESScanViewController * vc = [MESScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.scanType = scanApplyOutStoreInfo;
    vc.myDic = [NSDictionary dictionaryWithDictionary:mydic];
    vc.ScanBackB = ^(NSDictionary *dic) {
        //
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:tag inSection:1];
        BatchOutStoreTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
        cell.rightTF.text = dic[@"positionName"];
        NSDictionary *newdic = [NSDictionary dictionaryWithDictionary:dic];
        [self.dataArr replaceObjectAtIndex:tag-1 withObject:newdic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)OutStoreLocationChoose:(UIButton *)sender
{
    
    NSDictionary *dic = self.dataArr[sender.tag - 100 - 1];
    NSString *batch = [self isNullString:dic[@"batchNo"]];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            batch,@"batch",
                            self.dataDic[@"id"],@"id",
                            self.dataDic[@"materialId"],@"materialId",
                            dic[@"positionId"],@"positionId",
                            nil];
    WS(weakSelf)
    [UrlRequest requestOutStoreRequireLocationSearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {

        if (result) {
            
            [self StoreLocationsShow:[NSArray arrayWithArray:data] tag:sender.tag - 100];
        }
    }];
    
}

-(void)StoreLocationsShow:(NSArray *)dataArr tag:(NSInteger)tag
{
    
    if (!self.listV) {
        self.listV = [[BottomListShowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.listV.showFrom = bottomApplyOutStoreInfo;
        self.listV.backgroundColor = [UIColor clearColor];
        WS(weakSelf)
        self.listV.StoreLocationBack = ^(NSDictionary * _Nullable dic) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:tag inSection:1];
            BatchOutStoreTableViewCell *cell = [weakSelf.myTableView cellForRowAtIndexPath:indexpath];
            cell.rightTF.text = [NSString stringWithFormat:@"%@",dic[@"positionName"]];
            NSDictionary *newdic = [NSDictionary dictionaryWithDictionary:dic];
            [weakSelf.dataArr replaceObjectAtIndex:tag-1 withObject:newdic];
        };
    }
    self.listV.hidden = NO;
    self.listV.dataArr = dataArr;
    [self.view.window addSubview:self.listV];


}


- (NSString *)isNullString:(id)string {
    if (string == nil || string == NULL) {
        return @"";
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([string isMemberOfClass:[NSString class]]) {
            if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]) {
                return @"";
            }
    }
    
    return [NSString stringWithFormat:@"%@",string];
}

-(void)SubmitClick{
    
    [self OutStoreInfoSubmit];
}

-(void)OutStoreInfoSubmit
{
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.dataDic[@"demandId"],@"demandId",
                            self.totalN,@"outQty",
                            self.markStr,@"remark",
                            self.dataDic[@"businessType"],@"businessType",
                            self.dataArr,@"list",
                            self.recieverId,@"receiver",
                            nil];
    WS(weakSelf)
    [UrlRequest requestOutStoreRequireSubmitWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {

        if (result) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
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

//
//  ApplyInStoreInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/28.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "ApplyInStoreInfoViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "UnfoldStoreRequireTableViewCell.h"
#import "StoreInfoTableViewCell.h"
#import "TypeOneTableViewCell.h"
#import "TypeTwoTableViewCell.h"
#import "TypeThreeTableViewCell.h"
#import "TypeFourTableViewCell.h"

#import "RemarksView.h"
#import "StorePositionChooseViewController.h"
#import "SupplierChooseViewController.h"


@interface ApplyInStoreInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (assign, nonatomic) BOOL isUnfold;

@property (strong,nonatomic) RemarksView *remarksV;
@property (strong,nonatomic) UIButton *submitBtn;
@property (nonatomic,copy)NSString *markStr;

@property (nonatomic,copy)NSString *batchNo;//批号
@property (nonatomic,copy)NSString *outQty;//本次数量
@property (nonatomic,copy)NSString *positionId;
@property (nonatomic,copy)NSString *supplierId;
@property (nonatomic,copy)NSString *manufacturerId;


@end

@implementation ApplyInStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    self.isUnfold = YES;
    [self.view addSubview:self.myTableView];

    [self getApplyInStoreData];
    
}

-(void)getApplyInStoreData
{

    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.materialId,@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestInStoreRequireInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {

        if (result) {
            
            weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:data];
            [weakSelf.myTableView reloadData];
        }
    }];
}

-(void)setNavi
{
    self.title = @"填写入库信息";

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

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(16, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, SCREEN_WIDTH - 32, 50);
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
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kTopSafeAreaHeight + kStatusBarHeight + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
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
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [footerV addSubview:self.remarksV];
        [footerV addSubview:self.submitBtn];
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
            return 2;
        }
    }else if (section == 1)
    {
        if (self.dataDic) {
            return 6;
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
        }
        
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UnfoldStoreRequireTableViewCell *cell = [UnfoldStoreRequireTableViewCell cellWithTableView:tableView];
            [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.dataDic = self.dataDic;
            return cell;
        }else if (indexPath.row == 1){
            TypeOneTableViewCell *cell = [TypeOneTableViewCell cellWithTableView:tableView];
            WS(weakSelf)

            cell.GetValueB = ^(NSString *text) {
                NSLog(@"%@", text);
                weakSelf.batchNo = text;
            };
            return cell;
            
        }else if (indexPath.row == 2){
            TypeTwoTableViewCell *cell = [TypeTwoTableViewCell cellWithTableView:tableView];
            WS(weakSelf)

            cell.GetValueB = ^(NSString * text) {
                NSLog(@"%@", text);
                weakSelf.outQty = text;
            };
            return cell;

        }else if (indexPath.row == 3){
            TypeThreeTableViewCell *cell = [TypeThreeTableViewCell cellWithTableView:tableView];
            [cell.rightBtn addTarget:self action:@selector(StoreLocationChoose) forControlEvents:UIControlEventTouchUpInside];
            [cell.scanBtn addTarget:self action:@selector(LocationScan) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }else if (indexPath.row == 4){
            TypeFourTableViewCell *cell = [TypeFourTableViewCell cellWithTableView:tableView];
            [cell.rightBtn addTarget:self action:@selector(supplierChoose) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else if (indexPath.row == 5){
            TypeFourTableViewCell *cell = [TypeFourTableViewCell cellWithTableView:tableView];
            cell.TitleLabel.text = @"生产厂商";
            [cell.rightBtn addTarget:self action:@selector(producerChoose) forControlEvents:UIControlEventTouchUpInside];

            return cell;


        }else{
            return nil;
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

-(void)supplierChoose
{
    SupplierChooseViewController *vc = [[SupplierChooseViewController alloc] init];
    vc.type = 1;
    vc.materialId = self.materialId;
    vc.SupplierBack = ^(id  _Nullable dic) {
        NSLog(@"%@",dic);
        self.supplierId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        NSIndexPath *index = [NSIndexPath indexPathForRow:4 inSection:1];
        TypeFourTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.rightTF.text = dic[@"name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)producerChoose
{
    SupplierChooseViewController *vc = [[SupplierChooseViewController alloc] init];
    vc.type = 2;
    vc.materialId = self.materialId;
    vc.SupplierBack = ^(id  _Nullable dic) {
        NSLog(@"%@",dic);
        self.manufacturerId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        NSIndexPath *index = [NSIndexPath indexPathForRow:5 inSection:1];
        TypeFourTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.rightTF.text = dic[@"name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)StoreLocationChoose
{
    StorePositionChooseViewController *vc = [[StorePositionChooseViewController alloc] init];
    vc.materialId = self.materialId;
    vc.PositionBack = ^(NSDictionary*  _Nullable dic) {
        self.positionId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:1];
        TypeThreeTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.rightTF.text = dic[@"name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:1];
//    TypeThreeTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
//    cell.rightTF.text = @"大兴工厂";
}

-(void)LocationScan{
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
    MESScanViewController * vc = [MESScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.scanType = scanApplyInStoreInfo;
    vc.ScanBackB = ^(NSString * _Nullable code) {
        //
        NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:1];
        TypeThreeTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.rightTF.text = code;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)FlodClick:(UIButton *)sender
{
    self.isUnfold = sender.selected;
    sender.selected = !sender.selected;
    [self.myTableView reloadData];
}

-(void)SubmitClick
{
    
    if ((!self.outQty)||(self.outQty.length == 0)) {
        [self showToast:@"请填写数量"];
        return;
    }
    if ((!self.positionId)||(self.positionId.length == 0)) {
        [self showToast:@"请选择入库位置"];

        return;
    }
    if ((!self.batchNo)||(self.batchNo.length == 0)) {
        self.batchNo = @"";
    }
    if ((!self.supplierId)||(self.supplierId.length == 0)) {
        self.supplierId = @"";
    }
    if ((!self.manufacturerId)||(self.manufacturerId.length == 0)) {
        self.manufacturerId = @"";
    }
    
    
    [self SubmitRequireInStoreInfo];
}


-(void)SubmitRequireInStoreInfo
{
    NSString *totalQty = [self isNullString:self.dataDic[@"totalQty"]];
    if (totalQty.length == 0) {
        totalQty = @"0";
    }
    NSString *currentDate = [self getCurrentTimes];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.dataDic[@"id"],@"id",
                            self.batchNo,@"batchNo",
//                            currentDate,@"demandDate",
                            self.dataDic[@"demandId"],@"demandId",
                            self.dataDic[@"demandQty"],@"demandQty",
                            self.manufacturerId,@"manufacturerId",
                            self.dataDic[@"materialId"],@"materialId",
                            self.outQty,@"outQty",
                            self.positionId,@"positionId",
                            self.markStr,@"remark",
                            self.supplierId,@"supplierId",
                            totalQty,@"totalQty",
                            nil];
    WS(weakSelf)
    [UrlRequest requestSubmitInStoreRequireInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {

        if (result) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

-(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];

    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

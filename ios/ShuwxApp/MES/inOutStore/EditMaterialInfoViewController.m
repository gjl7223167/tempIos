//
//  EditMaterialInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "EditMaterialInfoViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "EditInStoreInfoTableViewCell.h"
#import "EditOutStoreInfoTableViewCell.h"

#import "SupplierChooseViewController.h"
#import "StorePositionChooseViewController.h"
#import "OutPositionChooseViewController.h"

@interface EditMaterialInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong,nonatomic) UIButton *submitBtn;
@property (strong,nonatomic) UIButton *cancelBtn;

@property (assign, nonatomic) BOOL isUnfold;

@end

@implementation EditMaterialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    self.isUnfold = NO;
    [self.view addSubview:self.myTableView];
}


-(void)setNavi
{
    self.title = @"编辑物料信息";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
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


- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake((SCREEN_WIDTH + 16)/2.0, 20, (SCREEN_WIDTH - 32 - 16)/2.0, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(16, 20, (SCREEN_WIDTH - 32 - 16)/2.0, 50);
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
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
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        [footerV addSubview:self.cancelBtn];
        [footerV addSubview:self.submitBtn];
        _myTableView.tableFooterView = footerV;
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if (self.isInStoreRoom) {
        EditInStoreInfoTableViewCell *cell = [EditInStoreInfoTableViewCell cellWithTableView:tableView];
        cell.dataDic = self.dataDic;
        [cell.PositionChooseBtn addTarget:self action:@selector(StoreLocationChoose) forControlEvents:UIControlEventTouchUpInside];
        [cell.PositionScanBtn addTarget:self action:@selector(LocationScan) forControlEvents:UIControlEventTouchUpInside];
        [cell.SupplierBtn addTarget:self action:@selector(supplierChoose) forControlEvents:UIControlEventTouchUpInside];
        [cell.ProduceBtn addTarget:self action:@selector(producerChoose) forControlEvents:UIControlEventTouchUpInside];
        cell.NumberTF.delegate = self;
        
        return cell;
    }else{
        EditOutStoreInfoTableViewCell *cell = [EditOutStoreInfoTableViewCell cellWithTableView:tableView];
        [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.dataDic = self.dataDic;
        
        [cell.positionChooseBtn addTarget:self action:@selector(OutStorePositionChoose) forControlEvents:UIControlEventTouchUpInside];
        [cell.positionScanBtn addTarget:self action:@selector(LocationScan) forControlEvents:UIControlEventTouchUpInside];
        cell.numberTF.delegate = self;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isInStoreRoom) {
        return 357.0;
    }else{
        if (self.isUnfold) {
            return 422.0;
        }
        return 275.0;
    }
    return 50.0;
}


-(void)FlodClick:(UIButton *)sender
{
    self.isUnfold = sender.selected;
    sender.selected = !sender.selected;
    
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    EditOutStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
    [muDic setValue:cell.numberTF.text forKey:@"outQty"];
    [muDic setValue:cell.numberTF.text forKey:@"realQty"];

    self.dataDic = muDic;
    
    [self.myTableView reloadData];
}


-(void)supplierChoose
{
    SupplierChooseViewController *vc = [[SupplierChooseViewController alloc] init];
    vc.type = 1;
    vc.materialId = self.dataDic[@"materialId"];
    vc.SupplierBack = ^(id  _Nullable dic) {
        NSLog(@"%@",dic);
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
        [muDic setValue:dic[@"id"] forKey:@"supplierId"];
        [muDic setValue:dic[@"name"] forKey:@"supplierName"];
        self.dataDic = muDic;
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        EditInStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.SupplierTF.text = dic[@"name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)producerChoose
{
    SupplierChooseViewController *vc = [[SupplierChooseViewController alloc] init];
    vc.type = 2;
    vc.materialId = self.dataDic[@"materialId"];
    vc.SupplierBack = ^(id  _Nullable dic) {
        NSLog(@"%@",dic);
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
        [muDic setValue:dic[@"id"] forKey:@"manufacturerId"];
        [muDic setValue:dic[@"name"] forKey:@"manufacturerName"];
        self.dataDic = muDic;
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        EditInStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.ProduceTF.text = dic[@"name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)StoreLocationChoose
{
    StorePositionChooseViewController *vc = [[StorePositionChooseViewController alloc] init];
    vc.materialId = self.dataDic[@"materialId"];
    vc.PositionBack = ^(NSDictionary*  _Nullable dic) {
        [self updatePosition:dic];
    };
    [self.navigationController pushViewController:vc animated:YES];
    

}

-(void)OutStorePositionChoose
{
    OutPositionChooseViewController *vc = [[OutPositionChooseViewController alloc] init];
    vc.dataDic = self.dataDic;
    vc.OutPositionBack = ^(NSDictionary *dic) {
        [self updatePosition:dic];

    };
    [self.navigationController pushViewController:vc animated:YES];
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
    if (self.isInStoreRoom) {
        vc.scanType = scanApplyInStoreInfo;
    }else{
        vc.scanType = scanApplyOutStoreInfo;
        vc.myDic = [NSDictionary dictionaryWithDictionary:self.dataDic];
    }
    vc.ScanBackB = ^(NSDictionary *dic) {
        //
        [self updatePosition:dic];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updatePosition:(NSDictionary *)dic
{
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
    if (dic[@"name"]) {
        [muDic setValue:dic[@"id"] forKey:@"positionId"];
        [muDic setValue:dic[@"name"] forKey:@"positionName"];
    }else{
        [muDic setValue:dic[@"positionId"] forKey:@"positionId"];
        [muDic setValue:dic[@"positionName"] forKey:@"positionName"];
    }
    
    
    if (self.isInStoreRoom) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        EditInStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.PositionTF.text = [NSString stringWithFormat:@"%@",muDic[@"positionName"]];
    }else{
        [muDic setValue:dic[@"qty"] forKey:@"qty"];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        
        EditOutStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        cell.positionTF.text = [NSString stringWithFormat:@"%@",muDic[@"positionName"]];
        cell.remainNumL.text = [NSString stringWithFormat:@"%@",muDic[@"qty"]];
    }
    
    self.dataDic = muDic;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)CancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SubmitClick{
    
    if (self.isInStoreRoom) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        EditInStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        if (cell.NumberTF.text.length == 0||[cell.NumberTF.text intValue] == 0) {
            [self showToast:@"请填写数量"];
            return;
        }
        if (cell.PositionTF.text.length == 0) {
            [self showToast:@"请选择入库位置"];
            return;
        }
        
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
        [muDic setValue:cell.NumberTF.text forKey:@"inQty"];
        self.dataDic = muDic;
        
        if (self.materialInfoB) {
            self.materialInfoB(self.dataDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        EditOutStoreInfoTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:index];
        if (cell.numberTF.text.length == 0||[cell.numberTF.text intValue] == 0) {
            [self showToast:@"请填写数量"];
            return;
        }
        if (cell.positionTF.text.length == 0) {
            [self showToast:@"请选择出库位置"];
            return;
        }
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
        
        [muDic setValue:cell.numberTF.text forKey:@"outQty"];
        [muDic setValue:cell.numberTF.text forKey:@"realQty"];

        self.dataDic = muDic;
        
        if (self.materialInfoB) {
            self.materialInfoB(self.dataDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
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

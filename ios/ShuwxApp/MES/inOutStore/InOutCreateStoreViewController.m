//
//  InOutCreateStoreViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InOutCreateStoreViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "RemarksView.h"

#import "StoreTypeSelectTableViewCell.h"
#import "StoreMaterialInfoTableViewCell.h"
#import "TypeFourTableViewCell.h"
#import "OutStoreMaterialTableViewCell.h"

#import "MaterialReceiverViewController.h"
#import "BottomListShowView.h"
#import "EditMaterialInfoViewController.h"

#import "noDataShowTableViewCell.h"

@interface InOutCreateStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *showArr;

@property (strong,nonatomic) RemarksView *remarksV;
@property (strong,nonatomic) UIButton *submitBtn;
@property (strong,nonatomic) UIButton *cancelBtn;

@property (nonatomic,copy) NSString *markStr;
@property (strong,nonatomic) NSString *recieverId;
@property (strong,nonatomic) NSString *businessId;

@property (strong,nonatomic) BottomListShowView *listV;

@end

@implementation InOutCreateStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.recieverId = @"";
    self.businessId = @"";

    [self setNavi];
    [self.view addSubview:self.myTableView];
    
    
}


-(void)setNavi
{
    if (self.isInStoreRoom) {
        self.title = @"新建入库单";
    }else{
        self.title = @"新建出库单";
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

- (RemarksView *)remarksV
{
    if (!_remarksV) {
        _remarksV = [[RemarksView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
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
        _submitBtn.frame = CGRectMake((SCREEN_WIDTH + 16)/2.0, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, (SCREEN_WIDTH - 32 - 16)/2.0, 50);
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
        _cancelBtn.frame = CGRectMake(16, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, (SCREEN_WIDTH - 32 - 16)/2.0, 50);
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
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [footerV addSubview:self.remarksV];
        [footerV addSubview:self.cancelBtn];
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
        if (self.isInStoreRoom) {
            return 1;
        }
        return 2;
    }else if (section == 1)
    {
        if (self.dataArr.count == 0) {
            return 1;
        }
        return self.dataArr.count;
    }
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            StoreTypeSelectTableViewCell *cell = [StoreTypeSelectTableViewCell cellWithTableView:tableView];
            [cell.chooseBtn addTarget:self action:@selector(TypeSelectClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else if (indexPath.row == 1){
            TypeFourTableViewCell *cell = [TypeFourTableViewCell cellWithTableView:tableView];
            cell.TitleLabel.text = @"收料人";
            [cell.rightBtn addTarget:self action:@selector(RecieverChoose) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
        return nil;
    }else if (indexPath.section == 1){
        if (self.dataArr.count == 0) {
            noDataShowTableViewCell *cell = [noDataShowTableViewCell cellWithTableView:tableView];
            cell.alertContentL.text = @"快去扫码添加数据吧";
            return cell;
        }else{
            NSDictionary *dic = self.dataArr[indexPath.row];
            
            if (self.isInStoreRoom) {
                StoreMaterialInfoTableViewCell *cell = [StoreMaterialInfoTableViewCell cellWithTableView:tableView];
                cell.editBtn.tag = 100 + indexPath.row;
                cell.deleteBtn.tag = 100 + indexPath.row;
                [cell.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.SerialNumberL.text = [NSString stringWithFormat:@"%ld/%lu",indexPath.row+1,(unsigned long)self.dataArr.count];
                
                cell.dataDic = dic;
                
                return cell;
            }else{
              OutStoreMaterialTableViewCell *cell = [OutStoreMaterialTableViewCell cellWithTableView:tableView];
                cell.foldBtn.tag = 100 + indexPath.row;
                cell.editBtn.tag = 100 + indexPath.row;
                cell.deleteBtn.tag = 100 + indexPath.row;
                [cell.foldBtn addTarget:self action:@selector(FlodClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
                
                int isUnfold = [self.showArr[indexPath.row] intValue];
                if (isUnfold == 1) {
                    cell.foldBtn.selected = NO;
                }else
                {
                    cell.foldBtn.selected = YES;
                }
                
                cell.serialNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",indexPath.row+1,(unsigned long)self.dataArr.count];

                cell.dataDic = dic;
                
                return cell;
            }
        }

    }
    
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.dataArr.count == 0) {
            return 120.0;
        }else{
            if (self.isInStoreRoom) {
                return 357.0;
            }else{
                int isUnfold = [self.showArr[indexPath.row] intValue];
                if (isUnfold == 1) {
                    return 438.0;
                }
                
                return 291.0;
            }
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
        return [self getHeaderV:infoStr rightStr:@"扫码" rightSel:@"MaterialScan"];
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
    
    if (rightS) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"instore_scan"] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(bottomV.frame.size.width - 18 - 16, 10, 18, 18);
        SEL sel = NSSelectorFromString(rightSel);
        [rightBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:rightBtn];
    }
    
    
    return currentState;
}

-(void)editClick:(UIButton *)sender
{
    NSDictionary *dic = self.dataArr[sender.tag - 100];
    [self editMaterial:dic with:sender.tag - 100];
    
}

-(void)deleteClick:(UIButton *)sender
{
    [self.dataArr removeObjectAtIndex:sender.tag - 100];
    [self.showArr removeObjectAtIndex:sender.tag - 100];
    
    [self.myTableView reloadData];
}

-(void)TypeSelectClick
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    @"IOM_type_c",@"dic_type",
    nil];
    if (self.isInStoreRoom) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
        @"IOM_type_r",@"dic_type",
        nil];
    }
    
    [UrlRequest requestSelectDictionaryByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            NSArray *dataArr = [NSArray arrayWithArray:data];
            [self BusinessTypeShow:dataArr];
        }
    }];
}

-(void)BusinessTypeShow:(NSArray *)dataArr
{
    if (!self.listV) {
        self.listV = [[BottomListShowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.listV.showFrom = bottomInOutCreateStore;
        WS(weakSelf)
        self.listV.StoreLocationBack = ^(NSDictionary * _Nullable dic) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            StoreTypeSelectTableViewCell *cell = [weakSelf.myTableView cellForRowAtIndexPath:indexpath];
            cell.chooseTF.text = [NSString stringWithFormat:@"%@",dic[@"dic_name"]];
            weakSelf.businessId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        };
    }
    self.listV.hidden = NO;
    self.listV.dataArr = dataArr;
    [self.view.window addSubview:self.listV];

}

-(void)RecieverChoose
{
    MaterialReceiverViewController *vc = [[MaterialReceiverViewController alloc] init];
    vc.RecieverBack = ^(NSDictionary *dic) {
        //收料人
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        TypeFourTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
        cell.rightTF.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.recieverId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)MaterialScan{
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
        vc.scanType = scanInOutCreateStore;
    }else{
        vc.scanType = scanInOutCreateStoreOut;
    }
    vc.ScanBackB = ^(id data) {

        NSMutableDictionary *mudic = [[NSMutableDictionary alloc] initWithDictionary:data];
        [self.navigationController popViewControllerAnimated:NO];
        if (self.isInStoreRoom) {
            [mudic setValue:@"" forKey:@"batchNo"];
            [mudic setValue:@"" forKey:@"inQty"];
            [mudic setValue:@"" forKey:@"manufacturerId"];
            [mudic setValue:@"" forKey:@"manufacturerName"];
            [mudic setValue:@"" forKey:@"supplierId"];
            [mudic setValue:@"" forKey:@"supplierName"];
            [mudic setValue:@"" forKey:@"positionId"];
            [mudic setValue:@"" forKey:@"positionName"];
            [mudic setValue:mudic[@"id"] forKey:@"materialId"];
        }else{
            [mudic setValue:@"" forKey:@"outQty"];
            [mudic setValue:@"" forKey:@"realQty"];
        }
        NSDictionary *newDic = [self handleDicValue:mudic];
        [self editMaterial:newDic with:self.dataArr.count];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editMaterial:(NSDictionary *)dic with:(NSInteger)index
{
    EditMaterialInfoViewController *vc = [[EditMaterialInfoViewController alloc] init];
    vc.isInStoreRoom = self.isInStoreRoom;
    vc.dataDic = dic;
    vc.materialInfoB = ^(NSDictionary * _Nonnull dic) {
        NSDictionary *materialDic = [NSDictionary dictionaryWithDictionary:dic];
        if (index == self.dataArr.count) {
            [self.dataArr addObject:materialDic];
            [self.showArr addObject:@"1"];
        }else{
            [self.dataArr replaceObjectAtIndex:index withObject:materialDic];
        }
        
        [self.myTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

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

-(void)CancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SubmitClick
{
    
    if ((!self.businessId)||(self.businessId.length == 0)) {
        [self showToast:@"请选择业务类型"];
        return;
    }
    
    if (self.dataArr.count == 0) {
        [self showToast:@"请添加物料信息"];
        return;
    }
    
    if (self.isInStoreRoom) {
        NSMutableArray *listArr = [[NSMutableArray alloc] initWithCapacity:6];
        for (NSDictionary *dic in self.dataArr) {
            NSDictionary*newDic = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"batchNo"],@"batchNo",
               dic[@"inQty"],@"inQty",
               dic[@"manufacturerId"],@"manufacturerId",
               dic[@"materialId"],@"materialId",
               dic[@"positionId"],@"positionId",
               dic[@"supplierId"],@"supplierId",
                nil];
            [listArr addObject:newDic];
        }
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.markStr,@"remark",//备注
                               self.businessId,@"type",//出入库类型
                                listArr,@"list",
                                nil];
        NSLog(@"");
        [UrlRequest requestInStoreSubmitWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            
            if (result) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else
    {
        NSMutableArray *listArr = [[NSMutableArray alloc] initWithCapacity:6];
        NSMutableArray *stockList = [[NSMutableArray alloc] initWithCapacity:6];
        for (NSDictionary *dic in self.dataArr) {
        
            NSDictionary*newDic = [NSDictionary dictionaryWithObjectsAndKeys:[self getStringWith:dic[@"batchNo"]],@"batchNo",
               dic[@"outQty"],@"outQty",
               dic[@"realQty"],@"realQty",
               [self getStringWith:dic[@"manufacturerId"]],@"manufacturerId",
               dic[@"materialId"],@"materialId",
               dic[@"positionId"],@"positionId",
               [self getStringWith:dic[@"supplierId"]],@"supplierId",
                nil];
            [listArr addObject:newDic];
            
            NSDictionary *newStock = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"id"],@"id",
                dic[@"outQty"],@"qty",
                 nil];
            
            [stockList addObject:newStock];
        }
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.recieverId,@"receiver",//收货人id
                               self.markStr,@"remark",//备注
                               self.businessId,@"type",//出入库类型
                                listArr,@"list",
                                stockList,@"stockList",
                                nil];
        NSLog(@"");
        [UrlRequest requestOutStoreSubmitWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            
            if (result) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}

-(NSString *)getStringWith:(id)Str
{
    if ([Str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",Str];
}

-(NSDictionary *)handleDicValue:(NSDictionary *)dic{
    NSArray *keys = dic.allKeys;
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithCapacity:dic.count + 1];
    for (NSString *key in keys) {
        NSString *value = dic[key];
        
        if ([value isKindOfClass:[NSNull class]]) {
            value = @"";
        }else if ([value isKindOfClass:[NSString class]]&&[value isEqualToString:@"<null>"]){
            value = @"";
        }
        [muDic setValue:value forKey:key];
    }
    NSDictionary *newdic = muDic.copy;
    return  newdic;
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

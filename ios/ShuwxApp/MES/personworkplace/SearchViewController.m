//
//  SearchViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SearchViewController.h"
#import "BaseTableView.h"
#import "UrlRequest.h"
#import <MJExtension.h>

#import "WorkOperatorModel.h"

#import "workTableViewCell.h"

#import "InOutRequireTableViewCell.h"

#import "StoreRequireInfomationViewController.h"
#import "StoreDetailRequireViewController.h"

#import "InOutStoreMainTableViewCell.h"
#import "InOutStoreDetailViewController.h"

#import "QualityPlanTableViewCell.h"

#import "QualityRecordModelViewController.h"
#import "UnqualityHandleViewController.h"

#import "UnqualityHandleListTableViewCell.h"
#import "UnqualityDetailViewController.h"

@interface SearchViewController ()<UINavigationControllerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic ,strong) NSString *keyString;

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setCustomBar];
    self.keyString = @"";
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:10];
    [self.view addSubview:self.myTableView];
    
    [self initSubviewsShow];
    // Do any additional setup after loading the view.
}



-(void)setCustomBar
{
    UIView *navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
    navbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navbar];
    
    NSInteger top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//    mes_back
    
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setImage:[[UIImage imageNamed:@"mes_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(12,top + 11,22,22)];
    [leftButton setTintColor: RGBA(102,120,102,1)];
    [navbar addSubview:leftButton];
    
    self.searchBar.frame = CGRectMake(48, top + 8, navbar.frame.size.width -48 - 69, 30);
    [navbar addSubview:self.searchBar];
    
    UIButton  *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:RGBA(0,137,255,1) forState:UIControlStateNormal];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];

    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(navbar.frame.size.width - 20 - 40,top + 12,40,20)];
    [navbar addSubview:rightButton];
    
}

-(void)rightBtnClick
{
    [self.searchBar resignFirstResponder];
    self.keyString =self.searchBar.text;
    [self searchResultByKey];

    NSLog(@"搜索关键词");
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setKeyString:(NSString *)keyString
{
    if (keyString&&keyString.length != 0) {
        _keyString = keyString;
    }
    else
    {
        _keyString = nil;
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    
    self.keyString = self.searchBar.text;
    [self searchResultByKey];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"--%@--",searchText);
}


#pragma mark - 搜索框
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入";
        _searchBar.backgroundImage = [[UIImage alloc]init];
        _searchBar.layer.borderColor = RGBA(0,137,255,1).CGColor;
        _searchBar.layer.borderWidth = 1;
        if (@available(iOS 13.0, *)) {
            _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
            //            _searchBar.searchTextField.backgroundColor = UIColorHex(eaeaea);

        } else {
            // Fallback on earlier versions
            UITextField*searchField = [_searchBar valueForKey:@"_searchField"];
                        searchField.font = [UIFont systemFontOfSize:12];
            //            searchField.backgroundColor = UIColorHex(eaeaea);
        }
//        if(self.keyString.length){
//            _searchBar.text = self.keyString;
//        }
        [[_searchBar layer] setCornerRadius:3];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.delegate  =self;
    }
    return _searchBar;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        [navigationController setNavigationBarHidden:NO animated:YES];
        
        if(navigationController.delegate == self){
            navigationController.delegate = nil;
        }
    }
}

- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 20 + 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
//        _myTableView.rowHeight = 50;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.searchFrom) {
        case searchMaterialCreate:
        case searchOperatorList:
        case searchWorkingProcedureMain:
        case searchStorePositionChoose:
        case searchSupplierChoose:
        case searchMaterialReceiver:
        case searchModelInOutStoreRequireMain:
        case searchOutPositionChoose:
        case searchStoreRoomManager:
        case searchQualityInspectionPlanManage:
        case searchUnqualityHandleMain:
            {
                return 50;
            }
            break;
        case searchWorkingProcedureMainDetail:
        {
            if ([self.paramSubStr isEqualToString:@"POM_woStatus_05"]||[self.paramSubStr isEqualToString:@"POM_woStatus_06"]) {
                return 236.0;
            }
            return 276.0;
        }break;
        case searchModelInOutStoreRequireMainDetail:
            {
                if ([self.paramSubStr isEqualToString:@"IOM_materialrequire_r_03"]||[self.paramSubStr isEqualToString:@"IOM_materialrequire_c_03"]) {
                    return 130;
                }
                return 170;
            }
            break;
        case searchStoreRoomManagerDetail:
        {
            return 164.0;
        }
            break;
        case searchQualityInspectionPlanManageDetail:
        {
            if ([self.paramSubStr isEqualToString:@"QOM_Inspection_status_04"]) {
                return 152.0;
            }
            return 192.0;
        }break;
        case searchUnqualityHandleMainDetail:
        {
            if ([self.paramSubStr isEqualToString:@"QOM_defective_product_disposal_03"]) {
                return 216 - 40;
            }
            return 216;
        }break;
        default:
            break;
    }
    return 50;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    switch (self.searchFrom) {
            case searchWorkingProcedureMain:
            case searchStoreRoomManager:
            case searchQualityInspectionPlanManage:
            case searchUnqualityHandleMain:
            {
                NSString *workName = self.dataArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",workName];
                return cell;

            }
            break;
            case searchWorkingProcedureMainDetail:
            {
                workTableViewCell *cell = [workTableViewCell cellWithTableView:tableView];
                cell.status = self.paramSubStr;
                cell.dataDic = self.dataArr[indexPath.row];
                
                return cell;
                
            }break;
            case searchMaterialCreate:
                {
                    NSDictionary *dic = self.dataArr[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",dic[@"materialName"],dic[@"materialCode"]];
                    return cell;

                }
                break;
            case searchOperatorList:
            {
                WorkOperatorModel *model = self.dataArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
                return cell;

            }
            break;
            case searchModelInOutStoreRequireMain:
            {
                
                NSString *workName = self.dataArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",workName];

                return cell;
            }
            break;
            case searchModelInOutStoreRequireMainDetail:
            {
                NSDictionary *dic = self.dataArr[indexPath.row];
                InOutRequireTableViewCell *requireCell = [InOutRequireTableViewCell cellWithTableView:tableView];
                requireCell.dataDic = dic;
                if (!self.isInStore) {
                    [requireCell.StoreBtn setTitle:@"出库" forState:UIControlStateNormal];
                }
                requireCell.StoreBtn.tag = 100 + indexPath.row;
                [requireCell.StoreBtn addTarget:self action:@selector(StoreClick:) forControlEvents:UIControlEventTouchUpInside];
                return requireCell;
            }
            break;
            case searchStorePositionChoose:
            case searchSupplierChoose:
            case searchMaterialReceiver:
            {
                NSDictionary *dic = self.dataArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                return cell;

            }
            break;
            case searchOutPositionChoose:
            {
                NSDictionary *dic = self.dataArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@    库存数量%@个",dic[@"positionName"],dic[@"qty"]];
                return cell;

            }
            break;
            case searchStoreRoomManagerDetail:
            {
                InOutStoreMainTableViewCell *cell = [InOutStoreMainTableViewCell cellWithTableView:tableView];
                NSDictionary *dic = self.dataArr[indexPath.row];
                cell.dataDic = dic;
                [cell.detailBtn addTarget:self action:@selector(InOutStoreDetail:) forControlEvents:UIControlEventTouchUpInside];
                cell.detailBtn.tag = 100 + indexPath.row;
                
                return cell;
            }
            break;
            case searchQualityInspectionPlanManageDetail:
            {
                QualityPlanTableViewCell *cell = [QualityPlanTableViewCell cellWithTableView:tableView];
                NSDictionary *dic = self.dataArr[indexPath.row];
                cell.skipBtn.tag = 100 + indexPath.row;
                [cell.skipBtn addTarget:self action:@selector(ToQualityRecord:) forControlEvents:UIControlEventTouchUpInside];
                cell.status = self.paramSubStr;
                cell.dataDic = dic;
                return cell;
            }break;
            case searchUnqualityHandleMainDetail:
            {
                UnqualityHandleListTableViewCell *cell = [UnqualityHandleListTableViewCell cellWithTableView:tableView];
                cell.dataDic = self.dataArr[indexPath.row];
                
                cell.deleteBtn.tag = indexPath.row + 100;
                cell.unqualityBtn.tag = indexPath.row + 100;
                
                [cell.deleteBtn addTarget:self action:@selector(DeleteItem:) forControlEvents:UIControlEventTouchUpInside];
                [cell.unqualityBtn addTarget:self action:@selector(UnqualityClick:) forControlEvents:UIControlEventTouchUpInside];
                if ([self.paramSubStr isEqualToString:@"QOM_defective_product_disposal_02"]) {
                    cell.deleteBtn.hidden = YES;
                }
                
                //    daizx_t zhixz_t  yiwc_t

                return cell;
                
            }break;
            default:
            {
                return cell;
            }
                break;
    }
        
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.searchFrom) {
        case searchWorkingProcedureMain:
        {
            NSString *code = self.dataArr[indexPath.row];
            self.searchFrom = searchWorkingProcedureMainDetail;
            [self searchWorkingProcedureMainDetail:code];
        }
            break;
        case searchWorkingProcedureMainDetail:
        {
            
        }
            break;
        case searchMaterialCreate:
            {
                NSDictionary *dic = self.dataArr[indexPath.row];
                if (_SearchBackB) {
                    _SearchBackB(dic);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case searchOperatorList:
        {
            WorkOperatorModel *model = self.dataArr[indexPath.row];
            if (_SearchBackB) {
                _SearchBackB(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        break;
        case searchModelInOutStoreRequireMain:
        {
            NSString *code = self.dataArr[indexPath.row];
            self.searchFrom = searchModelInOutStoreRequireMainDetail;
            [self searchModelInOutStoreRequireMainDetail:code];
        }
        break;
        case searchModelInOutStoreRequireMainDetail:
        {
            NSDictionary *dic = self.dataArr[indexPath.row];
            StoreRequireInfomationViewController *vc = [[StoreRequireInfomationViewController alloc] init];
            vc.isInStore = self.isInStore;
        //    vc.workOrderId = @"132";
            vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
        case searchStorePositionChoose:
        case searchSupplierChoose:
        case searchMaterialReceiver:
        case searchOutPositionChoose:
        {
            NSDictionary *dic = self.dataArr[indexPath.row];
            if (_SearchBackB) {
                _SearchBackB(dic);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        break;
        case searchStoreRoomManager:
        {
            NSString *code = self.dataArr[indexPath.row];
            self.searchFrom = searchStoreRoomManagerDetail;
            [self searchStoreRoomManagerDetail:code];
        }
        break;
        case  searchStoreRoomManagerDetail:
        {
            
        }
        break;
        case searchQualityInspectionPlanManage:
        {
            NSString *code = self.dataArr[indexPath.row];
            self.searchFrom = searchQualityInspectionPlanManageDetail;
            [self searchQualityInspectionPlanManageDetail:code];
        }
            break;
        case searchQualityInspectionPlanManageDetail:
        {
            NSDictionary *dic = self.dataArr[indexPath.row];
            QualityRecordModelViewController *vc = [[QualityRecordModelViewController alloc] init];
            vc.myId = [NSString stringWithFormat:@"%@",dic[@"id"]];
            vc.propertyArr = self.propertyArr;
            vc.isDetail = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case searchUnqualityHandleMain:
        {
            NSString *code = self.dataArr[indexPath.row];
            self.searchFrom = searchUnqualityHandleMainDetail;
            [self searchUnqualityHandleMainDetail:code];
        }break;
        case searchUnqualityHandleMainDetail:
        {
            NSDictionary *dic = self.dataArr[indexPath.row];
            UnqualityDetailViewController *vc = [[UnqualityDetailViewController alloc] init];
            vc.isDetail = YES;
            vc.unqualityDic = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        default:
            break;
    }
    
}

-(void)initSubviewsShow
{
    switch (self.searchFrom) {
            case searchWorkingProcedureMain:
            {
                self.searchBar.placeholder = @"请输入工序工单编号";
                
            }
            break;
        case searchMaterialCreate:
            {
                self.searchBar.placeholder = @"请输入物料编码/物料名称";
                [self searchMaterial];
            }
            break;
        case searchOperatorList:
        {
            self.searchBar.placeholder = @"请输入人员编号/名称";
            [self searchOperater];
        }
        break;
        case searchStorePositionChoose:
        case searchOutPositionChoose:
        {
            self.searchBar.placeholder = @"请输入库房库位";
        }
        break;
        case searchSupplierChoose:
        case searchMaterialReceiver:
        {
            self.searchBar.placeholder = @"请输入名称";
        }
        break;
        case searchModelInOutStoreRequireMain:
        case searchQualityInspectionPlanManage:
        {
            self.searchBar.placeholder = @"请输入物料编号";
        }
        break;
        case searchStoreRoomManager:
        case searchUnqualityHandleMain:
        {
            self.searchBar.placeholder = @"请输入编号";
        }
        break;
        default:
            break;
    }
}

-(void)searchResultByKey
{
    
    switch (self.searchFrom) {
        case searchWorkingProcedureMain:
        case searchWorkingProcedureMainDetail:
        {
            self.searchFrom = searchWorkingProcedureMain;
            [self searchWorkProcedure];
        }
        break;
        case searchMaterialCreate:
        {
            [self searchMaterial];
        }
        break;
        case searchOperatorList:
        {
            [self searchOperater];
        }
        break;
        case searchModelInOutStoreRequireMain:
        case searchModelInOutStoreRequireMainDetail:
        {
            self.searchFrom = searchModelInOutStoreRequireMain;
            [self searchModelInOutStoreRequireMain];
        }
        break;
        case searchStorePositionChoose:
        {
            [self searchStorePosition];
        }
        break;
        case searchSupplierChoose:
        {
            [self searchSupplier];
        }
        break;
        case searchMaterialReceiver:
        {
            [self searchMaterialReceiver];
        }
        break;
        case searchOutPositionChoose:
        {
            [self searchOutPositionChoose];
        }
        break;
        case searchStoreRoomManager:
        case searchStoreRoomManagerDetail:
        {
            self.searchFrom = searchStoreRoomManager;
            [self searchStoreRoomManager];
        }
        break;
        case searchQualityInspectionPlanManage:
        case searchQualityInspectionPlanManageDetail:
        {
            self.searchFrom = searchQualityInspectionPlanManage;
            [self searchQualityInspectionPlanManage];
        }
        break;
        case searchUnqualityHandleMain:
        case searchUnqualityHandleMainDetail:
        {
            self.searchFrom = searchUnqualityHandleMain;
            [self searchUnqualityHandleMain];
        }break;
        default:
            break;
    }
    
}

-(void)searchWorkProcedure
{
    NSDictionary * param;
    if (self.keyString) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                self.keyString,@"code",
                nil];
    }
    else
    {
        return;
    }
     
    WS(weakSelf)
    [UrlRequest requestSearchWorkBenchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.myTableView reloadData];
            });
        }
    }];
}

-(void)searchWorkingProcedureMainDetail:(NSString *)code
{
    NSString *status = [NSString stringWithFormat:@"%@",self.paramStr];
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            code,@"code",
                            status,@"status",
                            @"1",@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequest requestworkbenchappWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        [self.dataArr removeAllObjects];

        NSArray *arr = data[@"records"];
        if (result) {
            [weakSelf.dataArr addObjectsFromArray:arr];
        }
        [weakSelf.myTableView reloadData];
    }];
}

-(void)searchMaterial
{
    NSDictionary * param;
    if (self.keyString) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                self.paramDic[@"workOrderId"],@"workOrderId",
                self.keyString,@"materialName",
                self.keyString,@"materialCode",
                nil];
    }
    else
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
        self.paramDic[@"workOrderId"],@"workOrderId",
        nil];
    }
     
    WS(weakSelf)
    [UrlRequest requestMaterialNameListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.myTableView reloadData];
            });
        }
    }];
}

-(void)searchOperater
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"name",
                            nil];
    WS(weakSelf)
    [UrlRequest requestMaterialOperatorListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
//            mj_objectArrayWithKeyValuesArray
            [weakSelf.dataArr removeAllObjects];

            NSArray *modelArr = [WorkOperatorModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf.dataArr addObjectsFromArray:modelArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.myTableView reloadData];
            });
        }
    }];
    
    
}

-(void)searchStorePosition
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"name",
                            nil];
    WS(weakSelf)
    [UrlRequest requestSearchStoreRequirePosWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
//            mj_objectArrayWithKeyValuesArray
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.myTableView reloadData];
            });
        }
    }];
    
    
}

-(void)searchSupplier
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"name",
                            nil];
    [UrlRequest requestSupplierListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];
    }];
}

-(void)searchMaterialReceiver
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"name",
                            nil];
    [UrlRequest requestMaterialRecieverWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];
    }];
}

-(void)searchModelInOutStoreRequireMain
{
    
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"code",
                            self.paramStr,@"type",
                            nil];
    [UrlRequest requestRequireInOutStoreSearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        [self.dataArr removeAllObjects];
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];
    }];
}

-(void)searchModelInOutStoreRequireMainDetail:(NSString *)codeStr
{
    NSString *status = [NSString stringWithFormat:@"%@",self.paramStr];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    codeStr,@"code",
    status,@"status",
    @"1",@"pageNum",
    @"10",@"pageSize",
    nil];
    
    if (self.isInStore) {
        //入库需求
        [UrlRequest requestRequireInStoreListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];
            if (result) {
                NSArray *records = data[@"records"];
                [self.dataArr addObjectsFromArray:records];
                NSLog(@"dd");
            }
            [self.myTableView reloadData];
        }];
    }else
    {
        //出库需求
        [UrlRequest requestRequireOutStoreListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];

            if (result) {
                NSArray *records = data[@"records"];
                [self.dataArr addObjectsFromArray:records];
                NSLog(@"dd");
            }
            [self.myTableView reloadData];
        }];
    }

}

-(void)searchOutPositionChoose
{
    NSString *batchNo = self.paramDic[@"batchNo"];
    if([batchNo isKindOfClass:[NSNull class]])
    {
        batchNo = @"";
    }
    
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    self.paramDic[@"materialId"],@"materialId",
    batchNo,@"batchNo",
    keyS,@"name",
    nil];
    [UrlRequest requestOutStorePositionWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];
    }];
}

-(void)searchStoreRoomManager
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    keyS,@"code",
    nil];
    
    if (self.isInStore) {
        [UrlRequest requestInStoreSearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];
            if (result) {
                [self.dataArr addObjectsFromArray:data];
            }
            [self.myTableView reloadData];
        }];
    }else
    {
        [UrlRequest requestOutStoreSearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];
           if (result) {
               [self.dataArr addObjectsFromArray:data];
           }
           [self.myTableView reloadData];
       }];
    }
    
}

-(void)searchStoreRoomManagerDetail:(NSString *)codeStr
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    codeStr,@"code",
    @"",@"status",
    @"1",@"pageNum",
    @"10",@"pageSize",
    nil];
    
    if (self.isInStore) {
        [UrlRequest requestInStoreMainListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];
            if (result) {
                NSArray *records = data[@"records"];
                [self.dataArr addObjectsFromArray:records];
                 
            }
            [self.myTableView reloadData];
        }];
    }else
    {
        [UrlRequest requestOutStoreMainListDataWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            [self.dataArr removeAllObjects];
           if (result) {
               NSArray *records = data[@"records"];
               [self.dataArr addObjectsFromArray:records];
           }
           [self.myTableView reloadData];
       }];
    }
}

-(void)searchQualityInspectionPlanManage
{
    NSString *keyS = @"";
    if (self.keyString) {
        keyS = self.keyString;
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            keyS,@"code",
                            self.paramStr,@"status",
                            @"1",@"pageNum",
                            @"10",@"pageSize",
                            nil];
    
    [UrlRequest requestQualityInspectionSearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
         [self.dataArr removeAllObjects];
         if (result) {
             [self.dataArr addObjectsFromArray:data];
         }
         [self.myTableView reloadData];
    }];
}

-(void)searchQualityInspectionPlanManageDetail:(NSString *)code
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            code,@"code",
                            self.paramStr,@"status",
                            @"1",@"pageNum",
                            @"10",@"pageSize",
                            nil];
    
    [UrlRequest requestQualityInspectionListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
       [self.dataArr removeAllObjects];
       if (result) {
           NSArray *records = data[@"records"];
           [self.dataArr addObjectsFromArray:records];
           
       }
       [self.myTableView reloadData];
   }];
}

-(void)searchUnqualityHandleMain
{
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.keyString,@"code",
                             self.paramStr,@"status",
                             @"1",@"pageNum",
                             @"10",@"pageSize",
                             nil];
     WS(weakSelf)
     [UrlRequest requestUnqualitySearchWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
          [self.dataArr removeAllObjects];
          if (result) {
              [weakSelf.dataArr addObjectsFromArray:data];
          }
          [weakSelf.myTableView reloadData];
     }];
}

-(void)searchUnqualityHandleMainDetail:(NSString *)code
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            code,@"code",
                            self.paramStr,@"status",
                            @"1",@"pageNum",
                            @"10",@"pageSize",
                            nil];
    
    [UrlRequest requestUnqualityHandleListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
       [self.dataArr removeAllObjects];
       if (result) {
           NSArray *records = data[@"records"];
           [self.dataArr addObjectsFromArray:records];
           
       }
       [self.myTableView reloadData];
   }];
}








-(void)StoreClick:(UIButton *)sender
{
    NSDictionary *dic = self.dataArr[sender.tag - 100];
    StoreDetailRequireViewController *vc = [[StoreDetailRequireViewController alloc] init];
    vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    vc.isInStore = self.isInStore;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)InOutStoreDetail:(UIButton *)sender
{
    NSDictionary *dic = self.dataArr[sender.tag - 100];
    InOutStoreDetailViewController *vc = [[InOutStoreDetailViewController alloc] init];
    vc.isInStoreRoom = self.isInStore;
    vc.dataDic = dic;
    vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)ToQualityRecord:(UIButton *)sender
{
    NSDictionary *dic = self.dataArr[sender.tag - 100];
    int status = [dic[@"status"] intValue];
    if (status == 781) {
        
        UnqualityHandleViewController *vc = [[UnqualityHandleViewController alloc] init];
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        QualityRecordModelViewController *vc = [[QualityRecordModelViewController alloc] init];
        vc.myId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        vc.propertyArr = self.propertyArr;
        vc.isDetail = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)DeleteItem:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self DeleteUnquality:index];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)DeleteUnquality:(NSInteger)index
{
    NSDictionary *dic = self.dataArr[index];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           dic[@"id"],@"id",
                           nil];
    
    [UrlRequest requestDeleteUnqualityWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            [self.dataArr removeObjectAtIndex:index];
            [self.myTableView reloadData];
        }
    }];
}

-(void)UnqualityClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataArr[index];
    UnqualityDetailViewController *vc = [[UnqualityDetailViewController alloc] init];
    vc.isDetail = NO;
    vc.unqualityDic = dic;
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

//
//  ModelInOutStoreRequireMainViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/18.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "ModelInOutStoreRequireMainViewController.h"
#import "UrlRequest.h"
#import "UrlRequestModel.h"
#import "BaseTableView.h"
#import "MJRefresh.h"
#import <MJExtension.h>
#import "noNetWorkView.h"

#import "propertyModel.h"
#import "NSObject+modelValue.h"

#import "StoreRequireInfomationViewController.h"
#import "StoreDetailRequireViewController.h"

#import "StoreRequireListTableViewCell.h"
#import "StoreRequireListBottomTableViewCell.h"

@interface ModelInOutStoreRequireMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellNum;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;
@property (strong, nonatomic) NSMutableArray *propertyArr;
@property (strong, nonatomic) NSMutableArray *OutpropertyArr;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@end

@implementation ModelInOutStoreRequireMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;
    cellNum = 0;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:5];
//    self.dataArr = [NSMutableArray arrayWithObjects:@"12",@"142",@"122",@"172",@"112",@"162",@"102",@"1e2",@"132",@"152",@"172", nil];
    [self.view addSubview:self.myTableView];
    [self requestModelandData];
    
//    [self getListData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
}

-(void)updateStoreData
{
    [self.dataArr removeAllObjects];
    self.pageNum = 0;
    if (self.isInStore) {
        NSLog(@"更新了入库数据");
    }
    else
    {
        NSLog(@"更新了出库数据");
    }
    [self getWorkData];
//    [self getListData];
//    [self.myTableView reloadData];
}

-(void)requestModelandData
{
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getModelStyle:self.isInStore];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self.propertyArr ModelArrayHandleModelData];
        [self getWorkData];
        [self getModelStyle:!self.isInStore];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self.OutpropertyArr ModelArrayHandleModelData];
    });
    
}

- (NSMutableArray *)propertyArr
{
    if (!_propertyArr) {
        _propertyArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _propertyArr;
}

-(NSMutableArray *)OutpropertyArr
{
    if (!_OutpropertyArr) {
        _OutpropertyArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _OutpropertyArr;
}

-(void)getModelStyle:(BOOL)isInS
{
    NSString *code = @"demandOut";
    if (isInS) {
        code = @"demandIn";
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                code,@"code",
                                nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *dataD = data;
            NSArray *details = dataD[@"details"];
            NSArray *Arr = [propertyModel mj_objectArrayWithKeyValuesArray:details];
            if (isInS) {
                [weakSelf.propertyArr addObjectsFromArray:Arr];
            }else{
                [weakSelf.OutpropertyArr addObjectsFromArray:Arr];
            }
//            [weakSelf.propertyArr ModelShowArrFromshowPosition:1];
            
        }
        NSLog(@"ddddddd");
        dispatch_semaphore_signal(weakSelf.sema);
        
    }];
}


-(void)getWorkData
{
    NSString *code = @"demandOut";
    NSString *inOutBoundBilld = @"0";
    cellNum = self.OutpropertyArr.count;
    if (self.isInStore) {
        code = @"demandIn";
        inOutBoundBilld = @"1";
        cellNum = self.propertyArr.count;
    }
    NSString *status = [NSString stringWithFormat:@"%@",self.titleDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                        status,@"status",
                        inOutBoundBilld,@"inOutBoundBillId",
                        nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            code,@"code",
                            map,@"map",
                            pageN,@"pageNum",
                            @"10",@"pageSize",
                            nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkListByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        [weakSelf.myTableView.mj_footer endRefreshing];
        [weakSelf.myTableView.mj_header endRefreshing];
        
        if (result) {
            
            NSInteger total = [data[@"total"] integerValue];
            NSArray *recordsArr = data[@"records"];
            NSDictionary *propertyInfoDic = data[@"propertyInfo"];
            if (!(propertyInfoDic&&propertyInfoDic.count != 0)) {
                propertyInfoDic = nil;
            }
            NSArray *arr = nil;
            if (self.isInStore) {
                 arr = [weakSelf.propertyArr ModelArrayFromrecords:recordsArr propertyInfo:propertyInfoDic];
            }else{
                arr = [weakSelf.OutpropertyArr ModelArrayFromrecords:recordsArr propertyInfo:propertyInfoDic];
            }
            [weakSelf.dataArr addObjectsFromArray:arr];
            if (total == weakSelf.dataArr.count) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.myTableView reloadData];
            });
             
        }
        else
        {
//            self.noNetWorkV.hidden = NO;
            [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
        }

    }];
}


-(void)getListData
{
    NSString *status = [NSString stringWithFormat:@"%@",self.titleDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    @"",@"code",
    status,@"status",
    pageN,@"pageNum",
    @"10",@"pageSize",
    nil];
    
    if (self.isInStore) {
        //入库需求
        [UrlRequest requestRequireInStoreListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
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
            if (result) {
                NSArray *records = data[@"records"];
                [self.dataArr addObjectsFromArray:records];
                NSLog(@"dd");
            }
            [self.myTableView reloadData];
        }];
    }

}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.sectionHeaderHeight = 10;
//        _myTableView.rowHeight = 44;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0f)];
        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001f)];
//        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf.propertyArr removeAllObjects];
               //请求数据+刷新界面
            weakSelf.pageNum = 0;
            [weakSelf.dataArr removeAllObjects];
            [weakSelf getWorkData];
            
           }];
        
           self.myTableView.mj_header=header;
           
           //上拉刷新
           MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
               //调用刷新方法
               [weakSelf getWorkData];

           }];
           //footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
           footer.stateLabel.font = [UIFont systemFontOfSize:12];
           self.myTableView.mj_footer = footer;//添加上拉加载
           //    [self.myTableView.mj_header beginRefreshing];
           

    }
    return _myTableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.titleDic[@"dic_code"] isEqualToString:@"IOM_materialrequire_r_03"]||[self.titleDic[@"dic_code"] isEqualToString:@"IOM_materialrequire_c_03"]) {
        return cellNum;
    }
    return cellNum + 1 ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == cellNum) {
        StoreRequireListBottomTableViewCell *cell = [StoreRequireListBottomTableViewCell cellWithTableView:tableView];
        
        if (self.isInStore) {
            [cell updateSubViewsStyle:YES state:YES];
        }
        else
        {
            [cell updateSubViewsStyle:NO state:NO];
        }
//        cell.voucherDetailBtn.tag = 100 + indexPath.section;
//        [cell.voucherDetailBtn addTarget:self action:@selector(ToDetail:) forControlEvents:UIControlEventTouchUpInside];
        cell.storeBtn.tag = 100 + indexPath.section;
        [cell.storeBtn addTarget:self action:@selector(ToStore:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    StoreRequireListTableViewCell *cell = [StoreRequireListTableViewCell cellWithTableView:tableView];
    NSDictionary *dic = self.dataArr[indexPath.section];
    propertyModel *model = self.isInStore?self.propertyArr[indexPath.row]:self.OutpropertyArr[indexPath.row];
    cell.propertyM = model;
    cell.valueDic = dic;
    if (self.isInStore) {
//        cell.titleLabel.text = @"入库";
//        cell.subTitleLabel.text = self.titleDic[@"dic_name"];
    }
    else{
//        cell.titleLabel.text = @"出库";
//        cell.subTitleLabel.text = self.titleDic[@"dic_name"];
    }
    return cell;
    
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellNum == indexPath.row) {
        return 58;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"----%ld-----",(long)indexPath.section);
//    if (!self.isInStore) {
//        return;
//    }
    NSDictionary *dic = self.dataArr[indexPath.section];
    StoreRequireInfomationViewController *vc = [[StoreRequireInfomationViewController alloc] init];
    vc.isInStore = self.isInStore;
//    vc.workOrderId = @"132";
    vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"workOrderId"]];
    vc.status = self.titleDic[@"dic_code"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)ToDetail:(UIButton *)sender
{
    NSLog(@"----%ld-----",(long)sender.tag);
    if (!self.isInStore) {
        return;
    }
    StoreRequireInfomationViewController *vc = [[StoreRequireInfomationViewController alloc] init];
    vc.isInStore = self.isInStore;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ToStore:(UIButton *)sender
{
    NSLog(@"----%ld-----",(long)sender.tag);
    NSDictionary *dic = self.dataArr[sender.tag - 100];

//    if (!self.isInStore) {
//        return;
//    }
    StoreDetailRequireViewController *vc = [[StoreDetailRequireViewController alloc] init];
    vc.workOrderId = [NSString stringWithFormat:@"%@",dic[@"workOrderId"]];
    vc.isInStore = self.isInStore;
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

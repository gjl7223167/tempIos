//
//  QualityModelMainViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/15.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "QualityModelMainViewController.h"
#import "UrlRequest.h"
#import "UrlRequestModel.h"
#import "BaseTableView.h"
#import "MJRefresh.h"
#import <MJExtension.h>
#import "noNetWorkView.h"

#import "propertyModel.h"
#import "NSObject+modelValue.h"

#import "StoreRequireListTableViewCell.h"
#import "QualityMainBottomTableViewCell.h"
#import "QualityMainBottomLongTableViewCell.h"

#import "QualityRecordModelViewController.h"
#import "UnqualityHandleViewController.h"


@interface QualityModelMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellNum;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@end

@implementation QualityModelMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageNum = 0;
    cellNum = 0;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:5];

    [self.view addSubview:self.myTableView];
    [self requestModelandData];
    
}


-(void)requestModelandData
{
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getModelStyle];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self.propertyArr ModelArrayHandleModelData];
        [self getWorkData];
    });
    
}

- (NSMutableArray *)propertyArr
{
    if (!_propertyArr) {
        _propertyArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _propertyArr;
}


-(void)getModelStyle
{
    NSString *code = @"qualityInspection";
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                code,@"code",
                                nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *dataD = data;
            NSArray *details = dataD[@"details"];
            NSArray *Arr = [propertyModel mj_objectArrayWithKeyValuesArray:details];
            [weakSelf.propertyArr addObjectsFromArray:Arr];

//            [weakSelf.propertyArr ModelShowArrFromshowPosition:1];
            
        }
        NSLog(@"ddddddd");
        dispatch_semaphore_signal(weakSelf.sema);
        
    }];
}


-(void)getWorkData
{
    NSString *code = @"qualityInspection";
    cellNum = self.propertyArr.count;
    
    NSString *status = [NSString stringWithFormat:@"%@",self.titleDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                        status,@"status",
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
            arr = [weakSelf.propertyArr ModelArrayFromrecords:recordsArr propertyInfo:propertyInfoDic];

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

    if ([self.titleDic[@"dic_code"] isEqualToString:@"QOM_Inspection_status_04"]) {
        return cellNum;
    }
    return cellNum + 1 ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == cellNum) {
        if ([self.titleDic[@"dic_code"] isEqualToString:@"QOM_Inspection_status_03"])
        {
            QualityMainBottomLongTableViewCell *cell = [QualityMainBottomLongTableViewCell cellWithTableView:tableView];
            cell.bottomBtn.tag = indexPath.section + 100;
            [cell.bottomBtn addTarget:self action:@selector(UnqualifiedSectionActin:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        QualityMainBottomTableViewCell *cell = [QualityMainBottomTableViewCell cellWithTableView:tableView];
        [cell.bottomBtn addTarget:self action:@selector(RecordSectionActin:) forControlEvents:UIControlEventTouchUpInside];

        cell.bottomBtn.tag = indexPath.section + 100;
        return cell;
    }
    
    StoreRequireListTableViewCell *cell = [StoreRequireListTableViewCell cellWithTableView:tableView];
    NSDictionary *dic = self.dataArr[indexPath.section];
    propertyModel *model = self.propertyArr[indexPath.row];
    cell.propertyM = model;
    cell.valueDic = dic;
    
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
    
    NSDictionary *dic = self.dataArr[indexPath.section];
    
    QualityRecordModelViewController *vc = [[QualityRecordModelViewController alloc] init];
    vc.myId = [NSString stringWithFormat:@"%@",dic[@"workOrderId"]];
    vc.propertyArr = self.propertyArr;
    vc.isDetail = YES;
    vc.titleArr = self.titleArr;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)RecordSectionActin:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataArr[index];
    
    QualityRecordModelViewController *vc = [[QualityRecordModelViewController alloc] init];
    vc.myId = [NSString stringWithFormat:@"%@",dic[@"workOrderId"]];
    vc.propertyArr = self.propertyArr;
    vc.isDetail = NO;
    vc.titleArr = self.titleArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)UnqualifiedSectionActin:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataArr[index];
    
    UnqualityHandleViewController *vc = [[UnqualityHandleViewController alloc] init];
    NSMutableDictionary *muD = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [muD setValue:dic[@"inspectionType"] forKey:@"inspectionTypeName"];
    [muD setValue:dic[@"workOrderId"] forKey:@"id"];

    vc.dataDic = muD;
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

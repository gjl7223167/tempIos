//
//  WorkingModelMainViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WorkingModelMainViewController.h"
#import "BaseTableView.h"
#import "workTableViewCell.h"
#import "MJRefresh.h"
#import "UrlRequest.h"
#import "UrlRequestModel.h"

#import <MJExtension.h>

#import "WorkTaskViewController.h"
#import "ModelWorkTaskViewController.h"

#import "noNetWorkView.h"
#import "propertyModel.h"
#import "WorkPropertyTableViewCell.h"
#import "rightButtonTableViewCell.h"

#import "NSObject+modelValue.h"

@interface WorkingModelMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellNum;
    NSInteger showArrowIndex;
    bool isFirst;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int  pageNum;

@property (strong, nonatomic) noNetWorkView *noNetWorkV;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@end

@implementation WorkingModelMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;
    cellNum = 0;
    showArrowIndex = 100;
    isFirst = YES;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:11];
    [self.view addSubview:self.myTableView];
    
    [self requestModelandData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isFirst) {
        [self.myTableView.mj_header beginRefreshing];
    }
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
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"productionWorkOrder",@"code",
                                nil];
    WS(weakSelf)
    [UrlRequestModel requestWorkModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *dataD = data;
            NSArray *details = dataD[@"details"];
            NSArray *Arr = [propertyModel mj_objectArrayWithKeyValuesArray:details];
            [weakSelf.propertyArr addObjectsFromArray:Arr];
//            [weakSelf.propertyArr ModelShowArrFromshowPosition:1];
            self->cellNum = weakSelf.propertyArr.count;
            self->showArrowIndex = cellNum/2;
            for (NSDictionary *dic in details) {
//                NSLog(@"-----%@-----%@------%@-----%@--%@",dic[@"code"],dic[@"elementLabel"],dic[@"showFlag"],dic[@"bingdingModel"],dic[@"bingdingField"]);
            }
            
        }
        NSLog(@"ddddddd");
        dispatch_semaphore_signal(weakSelf.sema);
        
    }];
}


-(void)getWorkData
{
    NSString *status = [NSString stringWithFormat:@"%@",self.workDic[@"id"]];
    self.pageNum ++;
    NSString *pageN = [NSString stringWithFormat:@"%d",self.pageNum];
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                        status,@"status",
                        userId,@"executorId",
//                        @"d",@"keycode"
                        nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"productionWorkOrder",@"code",
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
            NSArray *arr = [weakSelf.propertyArr ModelArrayFromrecords:recordsArr propertyInfo:propertyInfoDic];
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
        
        self->isFirst = NO;
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
//            [weakSelf requestModelandData];
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
    if ([@"POM_woStatus_05" isEqualToString:self.workDic[@"dic_code"]]||[@"POM_woStatus_06" isEqualToString:self.workDic[@"dic_code"]]) {
        return cellNum;
    }
    return cellNum + 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == cellNum) {
        rightButtonTableViewCell *cell = [rightButtonTableViewCell cellWithTableView:tableView];
        cell.rightBtn.tag = 100 + indexPath.section;
        [cell cellSetStatus:self.workDic[@"dic_code"]];
        [cell.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WorkPropertyTableViewCell *cell = [WorkPropertyTableViewCell cellWithTableView:tableView];
    cell.propertyM = self.propertyArr[indexPath.row];
    cell.valueDic = self.dataArr[indexPath.section];
    if (showArrowIndex == indexPath.row) {
        cell.rightArrow.hidden = NO;
    }
    else
    {
        cell.rightArrow.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == cellNum) {
        return 60;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"----%ld-----",(long)indexPath.section);
    
    
    [self skipToWorkDetailPage:YES workOrderId:self.dataArr[indexPath.section][@"workOrderId"]];
    
}

-(void)rightBtnClick:(UIButton *)sender
{
    NSLog(@"-----btn = %ld",sender.tag - 100);
    NSString *status = self.workDic[@"dic_code"];
    if ([status isEqualToString:@"POM_woStatus_02"]) {
        [self startWork:sender.tag - 100];
    }else if([status isEqualToString:@"POM_woStatus_03"])
    {
        [self recordWork:sender.tag - 100];
    }else if([status isEqualToString:@"POM_woStatus_04"])
    {
        [self resumeWork:sender.tag - 100];
    }else{
        
    }
    
}

-(void)startWork:(NSInteger)index
{
    NSString *workOrderid = [NSString stringWithFormat:@"%@",self.dataArr[index][@"workOrderId"]];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                workOrderid,@"workOrderId",
                                nil];
    WS(weakSelf)
    [UrlRequest requestStartWorkWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            [weakSelf skipToWorkDetailPage:NO workOrderId:workOrderid];
        }
        
    }];
}

-(void)recordWork:(NSInteger)index
{
    NSString *workOrderid = [NSString stringWithFormat:@"%@",self.dataArr[index][@"workOrderId"]];

    [self skipToWorkDetailPage:NO workOrderId:workOrderid];
}

-(void)resumeWork:(NSInteger)index
{
    NSString *workOrderid = [NSString stringWithFormat:@"%@",self.dataArr[index][@"workOrderId"]];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            workOrderid,@"workOrderId",
                            @"2",@"type",
                                nil];
    WS(weakSelf)
    [UrlRequest requestStopAndResumeWorkWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf skipToWorkDetailPage:NO workOrderId:workOrderid];
        }
    }];

}

-(void)skipToWorkDetailPage:(BOOL)isDetail workOrderId:(NSString *)workOrderId
{
//    WorkTaskViewController *task = [[WorkTaskViewController alloc] init];
    ModelWorkTaskViewController *task = [[ModelWorkTaskViewController alloc] init];
    task.workOrderId = workOrderId;
    task.isDetail = isDetail;
    task.propertyArr = self.propertyArr;
    task.allTitleArr = self.allTitleArr;
    [self.navigationController pushViewController:task animated:YES];
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

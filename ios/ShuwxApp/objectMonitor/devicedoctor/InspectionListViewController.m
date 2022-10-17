//
//  InspectionListViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "InspectionListViewController.h"
#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface InspectionListViewController ()

@end

@implementation InspectionListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"InspectionListViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"InspectionListViewController"];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:255/255.0 alpha:1];
       _personNib = [UINib nibWithNibName:@"InspectionListTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       [self dataSource];
       [self setupRefreshData];
       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
       _hasMore = true;
       startRow = 1;
      
       [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
               NSString * myErrorId =   event.errorId;
             
             }];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getSelectJobPointInfoByObjectId];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}

- (UITableView *)tabelview {
    
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource.count && _hasMore)
    {
        return 2; // 增加一个加载更多
    }
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return self.dataSource.count;
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.dataSource count] <= 0) {
        return SCREEN_HEIGHT - NAV_HEIGHT;
    }
    if (indexPath.section == 0){
        return 150;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [self.dataSource count] <= 0) {
        
        // 加载更多
        static NSString * noDataLoadMore = @"EmptyCall";
        
        EmptyViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
        if (!loadCell)
        {
            loadCell = [_emptyNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        loadCell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return loadCell;
    }
    if (indexPath.section == 0) {
        static NSString *  InspectionListView = @"CellId";
        //自定义cell类
        InspectionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InspectionListView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
  
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * point_time =  [dicOne objectForKey:@"point_time"];
         NSString * point_name =  [dicOne objectForKey:@"point_name"];
         NSString * user_name =  [dicOne objectForKey:@"user_name"];
          int check_type =  [[dicOne objectForKey:@"check_type"] intValue];
        
        
          [cell.cellTime setTitle:point_time forState:UIControlStateNormal];
        cell.oneName.text = @"点位名称";
         cell.twoName.text = @"巡检人";
        cell.threeName.text = @"打点条件";
        
        cell.oneNameValue.text = point_name;
          cell.twoNameValue.text = user_name;
        
        if (check_type == 2) {
              cell.threeNameValue.text = @"二维码";
        }else{
             cell.threeNameValue.text = @"手动";
        }
        
     
        return cell;
    }
    
    // 加载更多
    static NSString * noDataLoadMore = @"CellIdentifierLoadMore";
    
    NoDateTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
    if (!loadCell)
    {
        loadCell = [_nodataNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
    }
    if (!_hasMore) {
        loadCell.loadLabel.text = @"--没有更多数据了--";
    }else{
        loadCell.loadLabel.text = @"自动加载更多";
    }
    return loadCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }

    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
          NSString * point_id =  [dicOne objectForKey:@"point_id"];
           NSString * job_id =  [dicOne objectForKey:@"job_id"];
           NSString * check_type =  [dicOne objectForKey:@"check_type"];
      NSString * target_type =  [dicOne objectForKey:@"target_type"];
     NSString * position =  [dicOne objectForKey:@"position"];
       NSString * point_name =  [dicOne objectForKey:@"point_name"];
       NSString * target_device_name =  [dicOne objectForKey:@"target_device_name"];
     NSString * target_position_detail =  [dicOne objectForKey:@"target_position_detail"];
      NSString * pos_name =  [dicOne objectForKey:@"pos_name"];
      NSString * sort =  [dicOne objectForKey:@"sort"];
    NSString * target_device_code =  [dicOne objectForKey:@"target_device_code"];
    
    if ([self isBlankString:target_device_name]) {
        target_device_name = @"";
    }
    if ([self isBlankString:target_position_detail]) {
           target_position_detail = @"";
       }
    if ([self isBlankString:pos_name]) {
              pos_name = @"";
          }
    
    InspectionListDetailsViewController * alartDetail = [[InspectionListDetailsViewController alloc] init];
          alartDetail.point_id = point_id;
          alartDetail.job_id = job_id;
          alartDetail.check_type = check_type;
     alartDetail.target_type = target_type;
      alartDetail.position = position;
     alartDetail.point_name = point_name;
     alartDetail.target_device_name = target_device_name;
      alartDetail.target_position_detail = target_position_detail;
       alartDetail.pos_name = pos_name;
    alartDetail.is_sort = sort;
    alartDetail.target_device_code = target_device_code;

    [self.navigationController pushViewController:alartDetail  animated:YES];
    
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    if (indexPath.section == 1){
        
        if (!_hasMore) {
            return;
        }
        [self getSelectJobPointInfoByObjectId];
        
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator startAnimating];
    
    // 加载下一页
    //    [self loadNextPage];
}

-(void)clearData{
    [self.dataSource removeAllObjects];
    startRow = 1;
    _hasMore = true;
    
}

-(void)loadNextPage{
    
    if ([self.dataSource count] >= total) {
        _hasMore = false;
        return;
    }
    startRow ++;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator stopAnimating];
}

// 获取报警列表
-(void)getSelectJobPointInfoByObjectId{
    
    NSMutableDictionary * dicnary = [self queryData];
     NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:@(20) forKey:@"pageSize"];
    [diction setValue:@(startRow) forKey:@"pageNum"];

    [diction setValue:self.object_id forKey:@"object_id"];
  
     [diction setValue:ptoken forKey:@"token"];
//    [diction setValue:module_type_doctor forKey:@"module_type"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectJobPointInfoByObjectId];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
            total =   [[responseObject objectForKey:@"total"] intValue];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectJobPointInfoByObjectId:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToastTwo:myResult];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setSelectJobPointInfoByObjectId:(NSMutableArray *)nsArr{
    for (NSMutableDictionary * nsmuTab in nsArr) {
        [self.dataSource addObject:nsmuTab];
    }
    [self.tableView reloadData];
    //你的操作
    [self loadNextPage];
    
    
}

@end

//
//  OrderIngViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "OrderIngViewController.h"
#import "WRNavigationBar.h"
#import "AllWorkOrderTableViewCell.h"



@interface OrderIngViewController ()

@end

@implementation OrderIngViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
               //  self.navigationItem.title = @"巡检线路详情";
                
                UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
                [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
                [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
                [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
                leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
                [leftButton setFrame:CGRectMake(0,0,40,40)];
                //    [leftButton sizeToFit];
                
                UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
                leftBarButton.enabled = YES;
                self.navigationItem.leftBarButtonItem = leftBarButton;
                
                
                // 设置导航栏颜色
                [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
                
                // 设置初始导航栏透明度
                [self wr_setNavBarBackgroundAlpha:1];
                
                // 设置导航栏按钮和标题颜色
                [self wr_setNavBarTintColor:[UIColor whiteColor]];
                [self wr_setNavBarTitleColor:[UIColor whiteColor]];
           
             [self initView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrderIngViewController"];
 //   [self getSelectMyJobLineInfoByPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderIngViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"AllWorkOrderTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
     _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
     _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
     
     _hasMore = true;
         startRow = 1;
     
     [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [self dataSource];
       [self setupRefreshData];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
           [weakSelf getSelectReceiveOrderInfoByPage];
            [weakSelf.uitableView.mj_header endRefreshing];
        });
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
       self.uitableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT -44);
}




- (UITableView *)tabelview {
    
    return _uitableView;
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
        static NSString *  AllWorkOrderViewTableCellView = @"CellId";
        //自定义cell类
        AllWorkOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllWorkOrderViewTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
       NSDictionary * dicOne  =   [_dataSource objectAtIndex:indexPath.row];
                      NSString * order_code = [dicOne objectForKey:@"order_code"];
                         NSString * type_name = [dicOne objectForKey:@"order_name"];
                       NSString * create_time = [dicOne objectForKey:@"create_time"];
                        NSString * reportTimeOut = [dicOne objectForKey:@"reportTimeOut"];
                NSString * receiveTimeOut = [dicOne objectForKey:@"receiveTimeOut"];
          if (nil == receiveTimeOut || receiveTimeOut == [NSNull null]) {
                  receiveTimeOut = @"0";
              }
                        NSString * plan_hour_num = [dicOne objectForKey:@"plan_hour_num"];
                  NSString * plan_start_time = [dicOne objectForKey:@"plan_start_time"];
                   NSString * content = [dicOne objectForKey:@"content"];
                NSString * status = [dicOne objectForKey:@"status"];
                NSString * content_type = [dicOne objectForKey:@"content_type"];
                NSString * start_set = [dicOne objectForKey:@"start_set"];
               
               NSMutableArray * statusList = [self getMainStatus:[status intValue]];
               NSString * statusName = [statusList objectAtIndex:0];
               NSString * statusColor = [statusList objectAtIndex:1];
               
                [cell.turnXj setTitle:statusName forState:UIControlStateNormal];
               [cell.turnXj setBackgroundColor:[self colorWithHexString:statusColor]];
               [cell.turnXj.layer setMasksToBounds:YES];
                     [cell.turnXj.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
               
               int reportTimeOutInt = [reportTimeOut intValue];
                int receiveTimeOutInt = [receiveTimeOut intValue];
                int start_setInt = 0;
                    if ([self getKeyIsNoValueIsNull:dicOne:@"start_set"]) {
                        start_setInt = [start_set intValue];
                    }
               
               if (reportTimeOutInt == 0 && receiveTimeOutInt == 0) {
                   [cell.overTime setHidden:YES];
               }else{
                     [cell.overTime setHidden:NO];
               }
               if (start_setInt == 2) {
                   [cell.oneSelf setHidden:NO];
               }else{
                      [cell.oneSelf setHidden:YES];
               }
               
                 [cell.orderCode setTitle:order_code forState:UIControlStateNormal];
               cell.myTaskName.text = type_name;
               cell.myTaskTime.text = plan_start_time;
               cell.myTaskDes.text = plan_hour_num;
        
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
    
    NSInteger myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }
    NSMutableDictionary * dictionary  =  [self.dataSource objectAtIndex:indexPath.row];
      NSString * order_id = [dictionary objectForKey:@"order_id"];
      
        OrderDetailsViewController * alartDetail = [[OrderDetailsViewController alloc] init];
      alartDetail.order_id = order_id;
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
     [self getSelectReceiveOrderInfoByPage];
        
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

-(void)getSelectReceiveOrderInfoByPage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@(20) forKey:@"pageSize"];
      [diction setValue:@(startRow) forKey:@"pageNum"];
    [diction setValue:@(3) forKey:@"table_value"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectMasOrderInfoPageList];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectReceiveOrderInfoByPage:myResult];
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
-(void)setSelectReceiveOrderInfoByPage:(NSMutableArray *) nsmutable{
    
     for (NSMutableDictionary * nsmuTab in nsmutable) {
          [self.dataSource addObject:nsmuTab];
      }
    self.dataSource = [self setDeduplication:self.dataSource];
      [self.uitableView reloadData];
      //你的操作
      [self loadNextPage];
}


@end

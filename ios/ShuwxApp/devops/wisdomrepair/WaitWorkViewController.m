//
//  MyTaskIngViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WaitWorkViewController.h"
#import "WRNavigationBar.h"


@interface WaitWorkViewController ()

@end

@implementation WaitWorkViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)dataSourceAll{
    if (!_dataSourceAll) {
        _dataSourceAll = [NSMutableArray array];
    }
    return _dataSourceAll;
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
    [MobClick beginLogPageView:@"WaitWorkViewController"];
    //   [self getSelectMyJobLineInfoByPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WaitWorkViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"AllWorkViewTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    _hasMore = true;
    startRow = 1;
    
    [self.allBtn.layer setMasksToBounds:YES];
    [self.allBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [self.allBtn.layer setBorderWidth:1.0];
    self.allBtn.layer.borderColor=[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
    [self.allBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//      [self.allBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    
    self.allBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
             self.chaosBtn.backgroundColor = [UIColor whiteColor];
             self.noChaoBtn.backgroundColor = [UIColor whiteColor];
       
        [self.allBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.chaosBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
       [self.noChaoBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    [self.chaosBtn.layer setMasksToBounds:YES];
    [self.chaosBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [self.chaosBtn.layer setBorderWidth:1.0];
    self.chaosBtn.layer.borderColor=[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
    [self.chaosBtn addTarget:self action:@selector(chaosBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
  
//       [self.chaosBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    [self.noChaoBtn.layer setMasksToBounds:YES];
    [self.noChaoBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [self.noChaoBtn.layer setBorderWidth:1.0];
    self.noChaoBtn.layer.borderColor=[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
    [self.noChaoBtn addTarget:self action:@selector(noChaosBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
  
//         [self.chaosBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      self.uitableView.showsVerticalScrollIndicator = NO;
    [self dataSource];
    [self dataSourceAll];
    [self setupRefreshData];
}
- (void)allBtnAction:(UIButton *)button{
    
    self.allBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
          self.chaosBtn.backgroundColor = [UIColor whiteColor];
          self.noChaoBtn.backgroundColor = [UIColor whiteColor];
    
     [self.allBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.chaosBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [self.noChaoBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
    self.tempInt = @"-1";
    
     [self setTimeOutData];
    
}
- (void)chaosBtnAction:(UIButton *)button{
    
    self.allBtn.backgroundColor = [UIColor whiteColor];
                 self.chaosBtn.backgroundColor =  [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
                 self.noChaoBtn.backgroundColor = [UIColor whiteColor];
    
[self.chaosBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
   [self.allBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
   [self.noChaoBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
     self.tempInt = @"1";
    
    [self setTimeOutData];
}

- (void)noChaosBtnAction:(UIButton *)button{
    
    self.allBtn.backgroundColor = [UIColor whiteColor];
                  self.noChaoBtn.backgroundColor =  [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
                  self.chaosBtn.backgroundColor = [UIColor whiteColor];
    
[self.noChaoBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
   [self.chaosBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
   [self.allBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    
     self.tempInt = @"0";
    
     [self setTimeOutData];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getSelectReceiveOrderYetInfoByPage];
            [weakSelf.uitableView.mj_header endRefreshing];
        });
    }];
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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
       self.uitableView.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 44 - 70);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [_dataSource count] <= 0) {
        
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
        static NSString *  WaitWorkTableCellView = @"CellId";
        //自定义cell类
        AllWorkViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WaitWorkTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
      
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
               NSString * order_code = [dicOne objectForKey:@"order_code"];
                  NSString * type_name = [dicOne objectForKey:@"type_name"];
                NSString * create_time = [dicOne objectForKey:@"create_time"];
                 NSString * reportTimeOut = [dicOne objectForKey:@"reportTimeOut"];
        NSString * receiveTimeOut = [dicOne objectForKey:@"receiveTimeOut"];
        NSString * target_type = [dicOne objectForKey:@"target_type"];
     
            NSString * content = [dicOne objectForKey:@"content"];
         NSString * status = [dicOne objectForKey:@"status"];
        NSString * target_position_name = [dicOne objectForKey:@"target_position_name"];
         NSString * target_position_detail = [dicOne objectForKey:@"target_position_detail"];
         NSString * device_position = [dicOne objectForKey:@"device_position"];
        
        NSMutableArray * statusList = [self getStatusName:[status intValue]];
        NSString * statusName = [statusList objectAtIndex:0];
        NSString * statusColor = [statusList objectAtIndex:1];
        
         [cell.wuxuXj setTitle:statusName forState:UIControlStateNormal];
        [cell.wuxuXj setBackgroundColor:[self colorWithHexString:statusColor]];
        [cell.wuxuXj.layer setMasksToBounds:YES];
              [cell.wuxuXj.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
        
        if ([self isBlankString:target_position_name]) {
            target_position_name = @"";
        }
        if ([self isBlankString:target_position_detail]) {
                  target_position_detail = @"";
              }
        if ([self isBlankString:device_position]) {
                      device_position = @"";
                  }
        
        target_position_name =  [self getPinjieNSString:target_position_name:target_position_detail];
           device_position =  [self getPinjieNSString:device_position:target_position_detail];
            
        NSString * myCode = [self getPinjieNSString:order_code:@"("];
        myCode = [self getPinjieNSString:myCode:type_name];
        myCode = [self getPinjieNSString:myCode:@")"];
        
               [cell.orderCode setTitle:myCode forState:UIControlStateNormal];
    
                cell.mytaskName.text = create_time;
               cell.mytaskdescri.text = content;
        
        int target_type_int = [target_type intValue];
        if (target_type_int == 2) {
               cell.mytaskTime.text = device_position;
        }else{
               cell.mytaskTime.text = target_position_name;
        }
        
        int reportTimeOut_int = [reportTimeOut intValue];
         int receiveTimeOut_int = [receiveTimeOut intValue];
        
        if (reportTimeOut_int == 0 && receiveTimeOut_int == 0) {
            [cell.orverTime setHidden:YES];
        }else{
             [cell.orverTime setHidden:NO];
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
       NSMutableDictionary * dictionary  =  [self.dataSource objectAtIndex:indexPath.row];
       NSString * order_id = [dictionary objectForKey:@"order_id"];
       
         WorkDetailsViewController * alartDetail = [[WorkDetailsViewController alloc] init];
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
        [self getSelectReceiveOrderYetInfoByPage];
        
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

-(void)getSelectReceiveOrderYetInfoByPage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSMutableArray * list = [NSMutableArray array];
    [list addObject:@"1"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@(20) forKey:@"pageSize"];
    [diction setValue:@(startRow) forKey:@"pageNum"];
    [diction setValue:list forKey:@"statusList"];
    
    NSString * url = [self getPinjieNSString:baseUrl :selectReceiveOrderYetInfoByPage];
  
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
            [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectReceiveOrderYetInfoByPage:myResult];
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
-(void)setSelectReceiveOrderYetInfoByPage:(NSMutableArray *) nsmutable{
    
    for (NSMutableDictionary * nsmuTab in nsmutable) {
        [self.dataSource addObject:nsmuTab];
        [self.dataSourceAll addObject:nsmuTab];
    }
    [self.uitableView reloadData];
    //你的操作
    [self loadNextPage];
}
-(void)setTimeOutData{
//    [self clearData];
     [self.dataSource removeAllObjects];
      _hasMore = false;
    
    if ([self getNSStringEqual:@"-1":_tempInt]) {
        for (NSMutableDictionary * nsmuTab in _dataSourceAll) {
            [self.dataSource addObject:nsmuTab];
        }
        [self.uitableView reloadData];
    }
    if ([self getNSStringEqual:@"1":_tempInt]) {
           for (NSMutableDictionary * nsmuTab in _dataSourceAll) {
               int reportTimeOut = [[nsmuTab objectForKey:@"reportTimeOut"] intValue];
               if (reportTimeOut == 1) {
                  [self.dataSource addObject:nsmuTab];
               }
           }
           [self.uitableView reloadData];
       }
    if ([self getNSStringEqual:@"0":_tempInt]) {
              for (NSMutableDictionary * nsmuTab in _dataSourceAll) {
                  int reportTimeOut = [[nsmuTab objectForKey:@"reportTimeOut"] intValue];
                  if (reportTimeOut == 0) {
                     [self.dataSource addObject:nsmuTab];
                  }
              }
              [self.uitableView reloadData];
          }
}


@end

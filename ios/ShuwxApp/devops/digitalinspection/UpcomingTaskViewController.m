//
//  UpcomingTaskViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "UpcomingTaskViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface UpcomingTaskViewController ()

@end

@implementation UpcomingTaskViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)allData{
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.uitableView.frame = CGRectMake(0,NAV_HEIGHT + 50,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.navigationItem.title = @"待办巡检任务";
    
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
    [MobClick beginLogPageView:@"UpcomingTaskViewController"];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UpcomingTaskViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    
    _personNib = [UINib nibWithNibName:@"UpcomingTaskTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.uitableView.showsVerticalScrollIndicator = NO;
    _hasMore = true;
      startRow = 1;
      refreshInt = -1;
    
    [self dataSource];
      [self allData];
    [self setupRefreshData];
    
    __weak typeof(self) weakSelf = self;
     [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
         __strong typeof(self) strongSelf = weakSelf;
             NSString * myErrorId =   event.errorId;
            if ([strongSelf getNSStringEqual:@"UpcomingTaskViewController":myErrorId]) {
                  [strongSelf clearData];
                    [strongSelf getSelectJobLineInfoByPage];
            }
           }];
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,50)];
        self.view1.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:self.view1];
    
    int myLengthtwo = 10;
     for (int i = 0;i<3;i++) {
         UIButton *sinaNme = [UIButton buttonWithType:(UIButtonTypeCustom)];
                sinaNme.frame = CGRectMake(myLengthtwo, 10, 50, 30);
           sinaNme.titleLabel.font = [UIFont systemFontOfSize: 12.0];
           [sinaNme setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:(UIControlStateNormal)];
         if (i == 0) {
                [sinaNme setTitle:@"全部"  forState:(UIControlStateNormal)];
             sinaNme.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
                            [sinaNme setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
         }
         if (i == 1) {
                      [sinaNme setTitle:@"未超时"  forState:(UIControlStateNormal)];
               }
         if (i == 2) {
                      [sinaNme setTitle:@"已超时"  forState:(UIControlStateNormal)];
               }
       
                [sinaNme addTarget:self action:@selector(allBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
                
                [sinaNme.layer setMasksToBounds:YES];
                [sinaNme.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
                [sinaNme.layer setBorderWidth:1.0];
                sinaNme.layer.borderColor=[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
                sinaNme.tag = i;
         
         [self.view1 addSubview:sinaNme];
                myLengthtwo += 55;
     }
}

- (void)allBtnAction:(UIButton *)button{
int buttonTag =  button.tag;
NSString * curTitle =  button.currentTitle;
    for (UIView *subView in self.view1.subviews) {
        if ( [subView isKindOfClass:[UIButton class]]) {
            UIButton * myButton = (UIButton *)subView;
              NSString * myTitle =  myButton.currentTitle;
            if ([self getNSStringEqual:curTitle:myTitle]) {
                 myButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
                 [myButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                [self setOrderSelect:curTitle];
            }else{
                   myButton.backgroundColor = [UIColor whiteColor];
                  [myButton setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
            }
        }
           NSLog(@"%@",subView);
       }
}
-(void)setOrderSelect:(NSString *)curString{
    if ([self getNSStringEqual:curString:@"全部"]) {
        refreshInt = -1;
    }
    if ([self getNSStringEqual:curString:@"未超时"]) {
           refreshInt = 0;
      }
    if ([self getNSStringEqual:curString:@"已超时"]) {
           refreshInt = 1;
      }
//    if ([self.allData count] < total) {
//        [self.allData removeAllObjects];
//        for (NSMutableDictionary * dicItem in self.dataSource) {
//            [self.allData addObject:dicItem];
//        }
////          self.allData = self.dataSource;
//      }
    if (refreshInt == -1){
        NSMutableArray * newArray = [NSMutableArray array];
        for (NSMutableDictionary * itemDic in self.allData) {
            [newArray addObject:itemDic];
        }
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:newArray];
                [self.uitableView reloadData];
    }
  
    if (refreshInt == 0){
        NSMutableArray * newArray = [NSMutableArray array];
        for (NSMutableDictionary * itemDic in self.allData) {
            int receiveTimeOut = [[itemDic objectForKey:@"receiveTimeOut"] intValue];
            if (receiveTimeOut != 1) {
                [newArray addObject:itemDic];
            }
        }
        [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:newArray];
        
        for (NSMutableDictionary * itemDic in newArray) {
            [self.dataSource addObject:itemDic];
        }
        
                [self.uitableView reloadData];
    }
    if (refreshInt == 1){
            NSMutableArray * noArray = [NSMutableArray array];
           for (NSMutableDictionary * itemDic in self.allData) {
               int receiveTimeOut = [[itemDic objectForKey:@"receiveTimeOut"] intValue];
               if (receiveTimeOut == 1) {
                             [noArray addObject:itemDic];
                         }
           }
        [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:noArray];
        for (NSMutableDictionary * itemDic in noArray) {
            [self.dataSource addObject:itemDic];
        }
                      [self.uitableView reloadData];
       }
}


- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf clearData];
            [strongSelf getSelectJobLineInfoByPage];
            [strongSelf.uitableView.mj_header endRefreshing];
        });
    }];
}


- (UITableView *)tabelview {
    
    return _uitableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allData.count && _hasMore)
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
        static NSString *  UpcmingTableCellView = @"CellId";
        //自定义cell类
        UpcomingTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UpcmingTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
          NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
                             NSString * job_code = [dicOne objectForKey:@"job_code"];
                              NSString * is_sort = [dicOne objectForKey:@"is_sort"];
                               NSString * pointCount = [dicOne objectForKey:@"pointCount"];
                                NSString * plan_name = [dicOne objectForKey:@"job_name"];
                              NSString * create_time = [dicOne objectForKey:@"create_time"];
                               NSString * plan_end_time = [dicOne objectForKey:@"plan_end_time"];
                               NSString * description = [dicOne objectForKey:@"description"];
                      int receiveTimeOut = [[dicOne objectForKey:@"receiveTimeOut"] intValue];
                             
                             job_code = [self getPinjieNSString:@" ":job_code];
                             int is_sort_int = [is_sort intValue];
                      
                             [cell.orderCode setTitle:job_code forState:UIControlStateNormal];
                      
                             pointCount = [self getIntegerValue:pointCount];
        
        cell.dwvalue.text = [self getPinjieNSString:@"点位：":pointCount];
                      
                      if (receiveTimeOut == 0) {
                          [cell.timeOutPic setHidden:YES];
                      }else{
                           [cell.timeOutPic setHidden:NO];
                      }
                             
                             NSString * isXj = @"";
                            
                             if (is_sort_int == 0) {
                                  isXj = [self getPinjieNSString:@"无序巡检":@""];
              //                    isXj = [self getPinjieNSString:isXj:pointCount];
                                 [cell.wuxXunj setTitle:isXj forState:UIControlStateNormal];
                                  [cell.wuxXunj setImage:[UIImage imageNamed:@"wuxuxj"] forState:UIControlStateNormal];
                             }else{
                                  isXj = [self getPinjieNSString:@"有序巡检":@""];
              //                    isXj = [self getPinjieNSString:isXj:pointCount];
                                 [cell.wuxXunj setTitle:isXj forState:UIControlStateNormal];
                                 [cell.wuxXunj setImage:[UIImage imageNamed:@"youxuxj"] forState:UIControlStateNormal];
                             }
                             NSString * myDate = @"";
                              create_time = [self getDeviceDateSixTwo:create_time];
                              plan_end_time = [self getDeviceDateSixTwo:plan_end_time];
                             
                             myDate = [self getPinjieNSString:create_time:@"-"];
                              myDate = [self getPinjieNSString:myDate:plan_end_time];
                             
                              cell.myTask.text = plan_name;
                             cell.taskTime.text = myDate;
                             cell.taskdescire.text = description;
        
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
    NSString * job_id = [dicOne objectForKey:@"job_id"];
    NSString * plan_id = [dicOne objectForKey:@"plan_id"];
    NSString * create_mode = [dicOne objectForKey:@"create_mode"];
    NSString * is_send = [dicOne objectForKey:@"is_send"];
    
    UpcomingTaskdetailsViewController *proViewVC = [UpcomingTaskdetailsViewController new];
    proViewVC.job_id = job_id;
    proViewVC.plan_id = plan_id;
    proViewVC.create_mode = create_mode;
      proViewVC.diction = dicOne;
    proViewVC.is_send = is_send;
    [self.navigationController pushViewController:proViewVC animated:YES];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    if (indexPath.section == 1 && refreshInt == -1){
        
        if (!_hasMore) {
            return;
        }
        [self getSelectJobLineInfoByPage];
        
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator startAnimating];
    
    // 加载下一页
    //    [self loadNextPage];
}

-(void)clearData{
    [self.dataSource removeAllObjects];
    [self.allData removeAllObjects];
    startRow = 1;
    _hasMore = true;
    
}

-(void)loadNextPage{
    
    if ([self.allData count] >= total) {
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


-(void)getSelectJobLineInfoByPage{
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
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectJobLineInfoByPage];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        self->total =   [[responseObject objectForKey:@"total"] intValue];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectJobLineInfoByPage:myResult];
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
-(void)setSelectJobLineInfoByPage:(NSMutableArray *) nsmutable{
    
    for (NSMutableDictionary * nsmuTab in nsmutable) {
        [self.allData addObject:nsmuTab];
    }
    [self.uitableView reloadData];
    //你的操作
    [self loadNextPage];
    
    NSString * refreshString = @"";
    if (refreshInt == -1) {
        refreshString = @"全部";
    }
    if (refreshInt == 0) {
        refreshString = @"未超时";
    }
    if (refreshInt == 1) {
        refreshString = @"已超时";
    }
    [self setOrderSelect:refreshString];
}



@end

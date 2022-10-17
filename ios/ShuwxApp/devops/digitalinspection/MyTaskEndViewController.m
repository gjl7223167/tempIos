//
//  MyTaskEndViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MyTaskEndViewController.h"
#import "WRNavigationBar.h"
#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"
#import "MyTaskIngTableViewCell.h"


@interface MyTaskEndViewController ()

@end

@implementation MyTaskEndViewController

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
    
    self.uitableView.frame = CGRectMake(0, 50,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50 - 44);
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
    [MobClick beginLogPageView:@"MyTaskEndViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyTaskEndViewController"];
   
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"MyTaskIngTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
       
       _hasMore = true;
           startRow = 1;
    refreshInt = -1;
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,50)];
     [self.view addSubview:view1];
    self.view1 = view1;
    
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
                     [sinaNme setTitle:@"未漏检"  forState:(UIControlStateNormal)];
              }
        if (i == 2) {
                     [sinaNme setTitle:@"漏检"  forState:(UIControlStateNormal)];
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
    
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self dataSource];
    [self allData];
         [self setupRefreshData];
    
    __weak typeof(self) weakSelf = self;
    [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
        __strong typeof(self) strongSelf = weakSelf;
             NSString * myErrorId =   event.errorId;
           if ([strongSelf getNSStringEqual:myErrorId:@"MyTaskEndViewController"]) {
                    [strongSelf clearData];
                          [strongSelf getSelectMyJobLineInfoByPage];
              }
           }];
}

- (void)allBtnAction:(UIButton *)button{
    NSInteger buttonTag =  button.tag;
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
    if ([self getNSStringEqual:curString:@"未漏检"]) {
           refreshInt = 0;
      }
    if ([self getNSStringEqual:curString:@"漏检"]) {
           refreshInt = 1;
      }
   
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
            if (receiveTimeOut == 0) {
                [newArray addObject:itemDic];
            }
        }
         [self clearData];
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
         [self clearData];
        for (NSMutableDictionary * itemDic in noArray) {
            [self.dataSource addObject:itemDic];
        }
                      [self.uitableView reloadData];
       }
}


- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            if (strongSelf->refreshInt == -1) {
                [strongSelf clearData];
               [strongSelf getSelectMyJobLineInfoByPage];
            }
         
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
        return SCREEN_HEIGHT - NAV_HEIGHT - 44;
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
        static NSString *  MyTaskIngTableCellView = @"CellId";
        //自定义cell类
        MyTaskIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTaskIngTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
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
                
        NSString * pointString = [self getIntegerValue:pointCount];
        pointString = [self getPinjieNSString:@"点位：":pointString];
               cell.pointValue.text = pointString;
                
                if (receiveTimeOut == 0) {
                    [cell.timeOutPic setHidden:YES];
                }else{
                     [cell.timeOutPic setHidden:NO];
                }
                       
                       NSString * isXj = @"";
                      
                       if (is_sort_int == 0) {
                            isXj = [self getPinjieNSString:@"无序巡检":@""];
        //                    isXj = [self getPinjieNSString:isXj:pointCount];
                           [cell.wuxuXj setTitle:isXj forState:UIControlStateNormal];
                            [cell.wuxuXj setImage:[UIImage imageNamed:@"wuxuxj"] forState:UIControlStateNormal];
                       }else{
                            isXj = [self getPinjieNSString:@"有序巡检":@""];
        //                    isXj = [self getPinjieNSString:isXj:pointCount];
                           [cell.wuxuXj setTitle:isXj forState:UIControlStateNormal];
                           [cell.wuxuXj setImage:[UIImage imageNamed:@"youxuxj"] forState:UIControlStateNormal];
                       }
                       NSString * myDate = @"";
                        create_time = [self getDeviceDateSixTwo:create_time];
                        plan_end_time = [self getDeviceDateSixTwo:plan_end_time];
                       
                       myDate = [self getPinjieNSString:create_time:@"-"];
                        myDate = [self getPinjieNSString:myDate:plan_end_time];
                       
                        cell.mytaskName.text = plan_name;
                       cell.mytaskTime.text = myDate;
                       cell.mytaskdescri.text = description;
        
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
      
     NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
                  NSString * line_id = [dicOne objectForKey:@"line_id"];
                   NSString * job_id = [dicOne objectForKey:@"job_id"];
    NSString * lose_content = [dicOne objectForKey:@"lose_content"];
    MyTaskDetailsNoViewController * alartDetail = [[MyTaskDetailsNoViewController alloc] init];
          alartDetail.line_id = line_id;
          alartDetail.job_id = job_id;
          alartDetail.diction = dicOne;
    alartDetail.loseContent = lose_content;
          [self.navigationController pushViewController:alartDetail  animated:YES];
    
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
        
     [self getSelectMyJobLineInfoByPage];
        
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

-(void)getSelectMyJobLineInfoByPage{
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
    [diction setValue:@"3" forKey:@"status"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectMyJobLineInfoByPage];
     
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectMyJobLineInfoByPage:myResult];
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
-(void)setSelectMyJobLineInfoByPage:(NSMutableArray *) nsmutable{
    
     for (NSMutableDictionary * nsmuTab in nsmutable) {
          [self.allData addObject:nsmuTab];
      }
    
    self.allData = [self setDeduplication:self.allData];
    
      [self.uitableView reloadData];
      //你的操作
      [self loadNextPage];
    
    
    NSString * refreshString = @"";
    if (refreshInt == -1) {
        refreshString = @"全部";
    }
    if (refreshInt == 0) {
        refreshString = @"未漏检";
    }
    if (refreshInt == 1) {
        refreshString = @"漏检";
    }
    [self setOrderSelect:refreshString];
}

@end

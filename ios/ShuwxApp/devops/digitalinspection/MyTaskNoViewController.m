//
//  MyTaskNoViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MyTaskNoViewController.h"
#import "WRNavigationBar.h"
#import "MyTaskIngTableViewCell.h"
#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface MyTaskNoViewController ()

@end

@implementation MyTaskNoViewController

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
    [MobClick beginLogPageView:@"ReviewIngViewController"];
//    [self getSelectMyJobLineInfoByPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ReviewIngViewController"];
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
      
      [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       [self dataSource];
        [self setupRefreshData];
    
        [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
               NSString * myErrorId =   event.errorId;
              if ([self getNSStringEqual:myErrorId:@"MyTaskNoViewController"]) {
                    [self clearData];
                      [self getSelectMyJobLineInfoByPage];
                }
             }];
}


- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
           [weakSelf getSelectMyJobLineInfoByPage];
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
                  
          //               pointCount = [self getIntegerValue:pointCount];
                  
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
    
    int myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }
    
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
                    NSString * line_id = [dicOne objectForKey:@"line_id"];
                     NSString * job_id = [dicOne objectForKey:@"job_id"];
            MyTaskDetailsNoViewController * alartDetail = [[MyTaskDetailsNoViewController alloc] init];
            alartDetail.line_id = line_id;
            alartDetail.job_id = job_id;
            alartDetail.diction = dicOne;
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
    [diction setValue:@"4" forKey:@"status"];
 
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
          [self.dataSource addObject:nsmuTab];
      }
    self.dataSource = [self setDeduplication:self.dataSource];
      [self.uitableView reloadData];
      //你的操作
      [self loadNextPage];
}


@end

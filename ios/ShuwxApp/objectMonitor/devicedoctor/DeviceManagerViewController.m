//
//  DeviceManagerViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/21.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "WRNavigationBar.h"
#import "AppDelegate.h"



@interface DeviceManagerViewController(){
    
}

@end
@implementation DeviceManagerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceManagerViewController"];
    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
  
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DeviceManagerViewController"];
    self.hidesBottomBarWhenPushed = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
//      self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.navigationItem.title = @"对象列表";
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"rightsanj"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton  *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"ditupic"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(toPopWin) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左显示
    [rightButton setFrame:CGRectMake(0,0,40,40)];
    
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    rightBarButton.enabled = YES;
    
    UIButton  *rightButtonOne  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButtonOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [rightButtonOne setImage:[UIImage imageNamed:@"sousuobtn"] forState:UIControlStateNormal];
    [rightButtonOne addTarget:self action:@selector(setSousuo) forControlEvents:UIControlEventTouchUpInside];
    rightButtonOne.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左显示
    [rightButtonOne setFrame:CGRectMake(0,0,40,40)];
    
    UIBarButtonItem * rightBarButtonOne = [[UIBarButtonItem alloc] initWithCustomView:rightButtonOne];
    rightBarButton.enabled = YES;
    
    
    //  self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.rightBarButtonItems = @[rightBarButtonOne,rightBarButton];
    
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    
    _personNib = [UINib nibWithNibName:@"ShuProManagerTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [self dataSource];
 
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    _tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
     _tableView.showsVerticalScrollIndicator = NO;
      _tableView.backgroundColor = [UIColor whiteColor];
    _hasMore = true;
    startRow = 1;
 
    [self setupRefreshData];
    
//    [self getAreaDeviceInfoByPageUp];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            
            [weakSelf getAreaDeviceInfoByPageUp];
            
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
        return 105;
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
        static NSString *  DeviceManagerTabView = @"DeviceManagerCellId";
    //   自定义cell类
        ShuProManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceManagerTabView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSMutableDictionary * dicNs =  [self.dataSource objectAtIndex:indexPath.row];
        NSString * projectName = [dicNs objectForKey:@"object_name"];
         NSString * object_code = [dicNs objectForKey:@"object_code"];
         NSString * location = [dicNs objectForKey:@"location"];
          NSString * run_totle_time = [dicNs objectForKey:@"run_totle_time"];
          NSString * alarm_total = [self getIntegerValue:[dicNs objectForKey:@"alarmMsgTotalNum"]];
        int object_type = [[dicNs objectForKey:@"object_type"] intValue];
       
        [cell.alarmSum setHidden:YES];
          cell.proName.numberOfLines = 0;//表示label可以多行显示
        if ([projectName length] > 28) {
            NSString * subString1 = [projectName substringToIndex:27];
              cell.proName.text = subString1;
        }else{
            cell.proName.text = projectName;
        }
        
        NSString * runTime = [self getIntegerValue:run_totle_time];
        
        if (object_type == 1) {
                  cell.fuzePerson.text = [self getPinjieNSString:@"项目编号：":object_code];
                         cell.proAddress.text = [self getPinjieNSString:@"项目地址：":location];
               }
               if (object_type == 2) {
                   cell.fuzePerson.text = [self getPinjieNSString:@"设备编号：":object_code];
                          cell.proAddress.text = [self getPinjieNSString:@"累计运行时间：":runTime];
               }
               if (object_type == 3) {
                    cell.fuzePerson.text = [self getPinjieNSString:@"编号：":object_code];
                          cell.proAddress.text = [self getPinjieNSString:@"地址：":location];
               }
        
       

        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.obtype.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 0)];
          CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
          maskLayer.frame = cell.obtype.bounds;
          maskLayer.path = maskPath.CGPath;
          cell.obtype.layer.mask = maskLayer;
        cell.obtype.layer.masksToBounds=YES;
        
    
        
        if (object_type == 1) {
            cell.obtype.text = @"项目";
//            cell.tubone.image = [UIImage imageNamed:@"myquyu"];
//              cell.tubtwo.image = [UIImage imageNamed:@"dingw"];
        }
        if (object_type == 2) {
            cell.obtype.text = @"设备";
//            cell.tubone.image = [UIImage imageNamed:@"biaoqian"];
//                       cell.tubtwo.image = [UIImage imageNamed:@"shijian"];
        }
        if (object_type == 3) {
            cell.obtype.text = @"其他";
//            cell.tubone.image = [UIImage imageNamed:@"myquyu"];
//                       cell.tubtwo.image = [UIImage imageNamed:@"dingw"];
        }
        
        //给图层添加一个有色边框 
          [cell.picImage.layer setMasksToBounds:YES];
        [cell.picImage.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
        cell.picImage.layer.borderWidth = 1; 
        cell.picImage.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0] CGColor]; 
        
        if ([dicNs objectForKey:@"device_img"]) {
            NSString * imgAddr = [dicNs objectForKey:@"device_img"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
            NSString * imageUrl =  [self getPinjieNSString:pictureUrl:imgAddr];
            
            NSString  * defaultImage = @"defaultpic";
//            [cell.picImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
            [cell.picImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
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
        [self getAreaDeviceInfoByPageUp];
        
    }
    
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
    
    NSString * deviceId = [self getIntegerValue:[dicOne objectForKey:@"device_id"]];
    NSString * device_name = [dicOne objectForKey:@"device_name"];
    
    
    ReportDeviceViewController * nextVC = [[ReportDeviceViewController alloc] init];
    nextVC.deviceId = deviceId;
        nextVC.deviceName = device_name;
    [self.navigationController pushViewController:nextVC  animated:YES];
}

-(void)setScan{
    [self.tabBarController.navigationController
    popToRootViewControllerAnimated:YES];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//           [appDelegate toShowTwo];
}
-(void)setSousuo{
    SearchDeviceViewController *searchDevice = [SearchDeviceViewController new];
    [self.navigationController pushViewController:searchDevice animated:YES];
}

-(void)toPopWin{
    LocationNewViewController * nextVC = [[LocationNewViewController alloc] init];
    [self.navigationController pushViewController:nextVC  animated:YES];
}


// 区域设备信息列表 查询接口
-(void)getAreaDeviceInfoByPageUp{
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:@(startRow) forKey:@"pageNum"];
    [diction setValue:@(20) forKey:@"pageSize"];
   
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :getAreaDeviceInfoByPage];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        total =   [[responseObject objectForKey:@"total"] intValue];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setAreaDeviceInfoByPageUp:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToast:myResult];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setAreaDeviceInfoByPageUp:(NSMutableArray *) nsArr{
    
    if ([nsArr count] <= 0) {
         [self.tableView reloadData];
        //你的操作
        [self loadNextPage];
        return;
    }
    
    for (NSMutableDictionary * dicItem in nsArr) {
        [self.dataSource addObject:dicItem];
    }
    [self.tableView reloadData];
    //你的操作
    [self loadNextPage];
}

@end

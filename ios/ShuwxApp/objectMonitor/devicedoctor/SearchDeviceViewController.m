//
//  SearchDeviceViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/14.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "WRNavigationBar.h"



@interface SearchDeviceViewController ()

@end

@implementation SearchDeviceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SearchDeviceViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SearchDeviceViewController"];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设备搜索";
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
    
    
    self.tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"输入设备名称";
    self.searchBar.delegate = self; // 设置代理
    
    [self dataSource];
    
    _personNib = [UINib nibWithNibName:@"DeviceManagerTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    _hasMore = true;
    startRow = 1;
   
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString * searchText =   searchBar.text;
    self.keysName = searchText;
      [self.dataSource removeAllObjects];
     [self.view endEditing:YES];
    [self getSelectDeviceInfo4MonitorByPage];
    
}



-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSelectDeviceInfo4MonitorByPage{
    
//    if ([self isBlankString:self.keysName]) {
//        [self showToast:@"请输入关键字"];
//        return;
//    }
    
    NSMutableDictionary * dicnary = [self queryData];
    
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:ptoken forKey:@"token"];
    [diction setValue:self.keysName forKey:@"device_name"];
     [diction setValue:@(startRow) forKey:@"pageNum"];
     [diction setValue:@(20) forKey:@"pageSize"];
  
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectDeviceInfo4MonitorByPage];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
             [self setSelectDeviceInfo4MonitorByPage:myResult];
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
-(void)setSelectDeviceInfo4MonitorByPage:(NSMutableArray *) nsArr{
  
    for (NSMutableDictionary * dicItem in nsArr) {
        [self.dataSource addObject:dicItem];
    }
    [self.tableView reloadData];
    //你的操作
    [self loadNextPage];
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
         return SCREEN_HEIGHT - NAV_HEIGHT ;
    }
    if (indexPath.section == 0){
        return 110;
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
        //自定义cell类
        DeviceManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceManagerTabView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
       NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
               NSString * deviceName = [dicOne objectForKey:@"device_name"];
               NSString * device_code = [dicOne objectForKey:@"device_code"];
               NSString * device_img  =  [dicOne objectForKey:@"device_img"];
               NSString * device_status_name = [dicOne objectForKey:@"device_status_name"];
               NSString * device_status_color = [dicOne objectForKey:@"device_status_color"];
               int run_totle_time = [[dicOne objectForKey:@"run_totle_time"] intValue];
               NSString * type_name = @"";
               if ([dicOne objectForKey:@"type_name"]) {
                   type_name = [dicOne objectForKey:@"type_name"];
               }
               NSString * alarmMsgTotalNum = @"";
               if ([dicOne objectForKey:@"alarmMsgTotalNum"]) {
                   alarmMsgTotalNum = [self getIntegerValue:[dicOne objectForKey:@"alarmMsgTotalNum"]];
               }
               
               
               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
               NSString * imageUrl = [self getPinjieNSString:pictureUrl:device_img];
               
               NSString * defaultImage = @"defaultpic";
                       
               if ([deviceName length] > 16) {
                   // User cannot type more than 15 characters
                   deviceName = [deviceName substringToIndex:16];
               }
                  cell.deviceName.preferredMaxLayoutWidth = 180;
               cell.deviceName.numberOfLines = 0;//表示label可以多行显示
               cell.deviceName.text = deviceName;
               cell.deviceFuze.text = [self getPinjieNSString:@"设备类型：":type_name];
               
               int day =   [self getDay:run_totle_time];
               int hour =   [self getHour:run_totle_time];
               
               NSString *dayStr = [NSString stringWithFormat:@"%d", day];
               NSString *hourStr = [NSString stringWithFormat:@"%d", hour];
               
               NSString * myHour = @"";
               if ([self getNSStringEqual:dayStr:@"0"]) {
                   myHour =    [self getPinjieNSString:dayStr:@"小时"];
               }
               else  if ([self getNSStringEqual:hourStr:@"0"]) {
                   myHour =    [self getPinjieNSString:dayStr:@"天"];
               }else{
                   myHour =  [self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:dayStr:@"天"]:hourStr]:@"小时"];
               }
               
               cell.deviceAddr.text = [self getPinjieNSString:@"累计运行时间：":myHour];
               
                cell.alarmSum.text = alarmMsgTotalNum;
               
               cell.alarmSum.layer.cornerRadius=cell.alarmSum.bounds.size.width/2;
               cell.alarmSum.layer.masksToBounds=YES;
               
               if ([self getNSStringEqual:alarmMsgTotalNum:@"0"]) {
                          [cell.alarmSum setHidden:YES];
                      }
               
           
               cell.deviceState.text = device_status_name;
               
               UIColor * myColor = [self colorWithHexString:device_status_color];
               cell.deviceState.textColor = myColor;
               
               cell.deviceState.layer.cornerRadius = 10;
               cell.deviceState.layer.borderWidth = 1;
               cell.deviceState.layer.borderColor = myColor.CGColor;
               
               cell.deviceState.preferredMaxLayoutWidth = 200;
               cell.deviceState.numberOfLines = 0;
               
               [cell.devicePic sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
               
               //给图层添加一个有色边框 
                [cell.devicePic.layer setMasksToBounds:YES];
               cell.devicePic.layer.borderWidth = 1; 
                [cell.devicePic.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
               cell.devicePic.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0] CGColor]; 
        
        
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
        if ([self isBlankString:self.keysName]) {
            //  [self showToast:@"请输入关键字"];
            return;
        }
        [self getSelectDeviceInfo4MonitorByPage];
        
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
    
    long myInt =  indexPath.section;
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

@end

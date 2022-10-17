//
//  DeviceMaintainViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/6.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "DeviceMaintainViewController.h"
#import "WRNavigationBar.h"



  static NSString *  ShuMaintainView = @"CellId";


@interface DeviceMaintainViewController ()
@property(nonatomic,strong) NSMutableDictionary *offScreenCell;
@end

@implementation DeviceMaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  //  self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:255/255.0 alpha:1];
//    _personNib = [UINib nibWithNibName:@"XLHTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
   
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNib = [UINib nibWithNibName:@"DeviceMaintainTableViewCell" bundle:nil]; //这句话就相当于
    [self dataSource];
     self.offScreenCell = [NSMutableDictionary new];
    [self setupRefreshData];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:255/255.0 alpha:1];
      self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    _hasMore = true;
    startRow = 1;
    
      [self.baoyBtn addTarget:self action:@selector(setBaoyDialog) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIImageView * imageview in self.myprogress.subviews) {
        
        imageview.layer.cornerRadius = 3;
        
        imageview.clipsToBounds = YES;
        
    }
    
    NSMutableDictionary * dicnary = [self queryData];
    
    self.userNikeName = [dicnary objectForKey:@"user_nike_name"];
    
    [self getBusDeviceCareDate];
    [self getSelectBusDeviceCareNearlyNotesByDeviceId];
    
}
-(void)setBaoyDialog{
    
    NSString * care_time = [self.nsmuCare objectForKey:@"care_time"];
    NSString * next_care_time = [self.nsmuCare objectForKey:@"next_care_time"];
    NSString * curDate = [self getCurrentTimes];
    
    if ([self isBlankString:care_time] || [self isBlankString:next_care_time]) {
        BaoyangAddDialog * controller = [BaoyangAddDialog new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSMutableDictionary *passedValue){
            
            [self getAddBusDeviceCareNotes:passedValue];
            
        };
         controller.firstByDate = self.firstByDate;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    
    if(true){
        BaoyangAddDialog * controller = [BaoyangAddDialog new];
              //赋值Block，并将捕获的值赋值给UILabel
              controller.returnValueBlock = ^(NSMutableDictionary *passedValue){
                  
                   [self getAddBusDeviceCareNotes:passedValue];
                  
              };
              controller.firstByDate = self.firstByDate;
              controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
              controller.providesPresentationContextTransitionStyle = YES;
              controller.definesPresentationContext = YES;
              controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
              
              //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
              [self presentViewController:controller animated:YES completion:nil];
              return;
    }
    
    int day =  [self getDateday:care_time endTime:curDate];
    if (day <= 15) {
        
        BaoyangEditDialog * controller = [BaoyangEditDialog new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSMutableDictionary *passedValue){
            
              [self getModifyBusDeviceCareNotesById:passedValue];
            
        };
        controller.nsmuCare = self.nsmuCare;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
    
        return;
    }
    int dayTwo =  [self getDateday:next_care_time endTime:curDate];
    if (dayTwo <= 15) {
        
        BaoyangAddDialog * controller = [BaoyangAddDialog new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSMutableDictionary *passedValue){
            
             [self getAddBusDeviceCareNotes:passedValue];
            
        };
        controller.firstByDate = self.firstByDate;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
}

// 获取保养信息
-(void)getAddBusDeviceCareNotes:(NSMutableDictionary *)myCateDic{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    NSString *userId = [self getIntegerValue:[dicnary objectForKey:@"user_id"]];
    
     NSString *baoyTime = [myCateDic objectForKey:@"baoyTime"];
      NSString *workTime = [myCateDic objectForKey:@"workTime"];
      NSString *careContent = [myCateDic objectForKey:@"careContent"];
      NSString *careRemarks = [myCateDic objectForKey:@"careRemarks"];
      NSString *careTimeNext = [myCateDic objectForKey:@"careTimeNext"];
      NSString *runWorkTime = [myCateDic objectForKey:@"runWorkTime"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:self.deviceId forKey:@"device_id"];
    [diction setValue:ptoken forKey:@"token"];
     [diction setValue:userId forKey:@"create_user_id"];
      [diction setValue:baoyTime forKey:@"care_time"];
      [diction setValue:workTime forKey:@"run_total_time"];
     [diction setValue:careContent forKey:@"content"];
     [diction setValue:careRemarks forKey:@"remarks"];
     [diction setValue:careTimeNext forKey:@"next_care_time"];
      [diction setValue:runWorkTime forKey:@"plan_run_time"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :addBusDeviceCareNotes];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setAddBusDeviceCareNotes:myResult];
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
-(void)setAddBusDeviceCareNotes:(NSMutableDictionary *)nsArr{
    [self getSelectBusDeviceCareNearlyNotesByDeviceId];
}

// 获取保养信息
-(void)getModifyBusDeviceCareNotesById:(NSMutableDictionary *)myCateDic{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    NSString *userId = [self getIntegerValue:[dicnary objectForKey:@"user_id"]];
    
    NSString *baoyTime = [myCateDic objectForKey:@"baoyTime"];
    NSString *workTime = [myCateDic objectForKey:@"workTime"];
    NSString *careContent = [myCateDic objectForKey:@"careContent"];
    NSString *careRemarks = [myCateDic objectForKey:@"careRemarks"];
    NSString *careTimeNext = [myCateDic objectForKey:@"careTimeNext"];
    NSString *runWorkTime = [myCateDic objectForKey:@"runWorkTime"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:self.deviceId forKey:@"device_id"];
    [diction setValue:ptoken forKey:@"token"];
    [diction setValue:userId forKey:@"create_user_id"];
    [diction setValue:baoyTime forKey:@"care_time"];
    [diction setValue:workTime forKey:@"run_total_time"];
    [diction setValue:careContent forKey:@"content"];
    [diction setValue:careRemarks forKey:@"remarks"];
    [diction setValue:careTimeNext forKey:@"next_care_time"];
    [diction setValue:runWorkTime forKey:@"plan_run_time"];
    

  NSString * care_id = [self getIntegerValue:[_nsmuCare objectForKey:@"care_id"]];
     [diction setValue:care_id forKey:@"care_id"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :modifyBusDeviceCareNotesById];
   
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setModifyBusDeviceCareNotesById:myResult];
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
-(void)setModifyBusDeviceCareNotesById:(NSMutableDictionary *)nsArr{
    [self getSelectBusDeviceCareNearlyNotesByDeviceId];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceMaintainViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DeviceMaintainViewController"];
}


- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            
            [weakSelf getSelectBusDeviceCareNotesByPage];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}

// 获取保养信息
-(void)getSelectBusDeviceCareNearlyNotesByDeviceId{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
   
    [diction setValue:self.deviceId forKey:@"device_id"];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectBusDeviceCareNearlyNotesByDeviceId];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
           
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
             [self setSelectBusDeviceCareNearlyNotesByDeviceId:myResult];
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
-(void)setSelectBusDeviceCareNearlyNotesByDeviceId:(NSMutableDictionary *)nsArr{
    self.nsmuCare = nsArr;
    NSString * next_care_time = [nsArr objectForKey:@"next_care_time"];
     NSString * runTotalTime = [self getIntegerValue:[nsArr objectForKey:@"run_total_time"]];
    NSString * plan_run_time = @"0";
    if ([nsArr objectForKey:@"plan_run_time"]) {
         plan_run_time = [self getIntegerValue:[nsArr objectForKey:@"plan_run_time"]];
    }
    self.topCareTime.text = next_care_time;
    self.topRunWorkTime.text = [self getPinjieNSString:plan_run_time:@"小时"] ;
    self.topWoredTime.text = [self getPinjieNSString:[self getPinjieNSString:@"已工作":runTotalTime]:@"小时"];
    
    int planRunTime = [plan_run_time intValue];
    
    double baifenbi = 0;
    if (planRunTime <= 0) {
        [self.myprogress setProgress:0];
        return;
    }
    int runTotalTimeInt = [runTotalTime intValue];
    if (runTotalTimeInt <= 0) {
        baifenbi = 0;
    }else{
       baifenbi =  (double)baifenbi / planRunTime * 100;
        
    }
     [self.myprogress setProgress:baifenbi];
    
  
}

// 获取保养列表
-(void)getSelectBusDeviceCareNotesByPage{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:@(20) forKey:@"pageSize"];
    [diction setValue:@(startRow) forKey:@"pageNum"];
    
    [diction setValue:self.deviceId forKey:@"device_id"];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectBusDeviceCareNotesByPage];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setProjectList:myResult];
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
-(void)setProjectList:(NSMutableArray *)nsArr{
    
    if ([nsArr count] <= 0) {
        　[self.baoyBtn setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        　[self.baoyBtn setTitle:@"保养" forState:UIControlStateNormal];
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
          return SCREEN_HEIGHT - NAV_HEIGHT - 40 - 240;
    }
    if (indexPath.section == 0){
        
//        XLHTableViewCell *cell = [self.offScreenCell objectForKey:ShuMaintainView];
//        if (!cell) {
//            cell = [[XLHTableViewCell alloc]init];
//            [self.offScreenCell setObject:cell forKey:ShuMaintainView];
//        }
//        XLHModel *model = self.dataSource[indexPath.row];
//        [cell.label setText:model.title];
//        cell.label.state = model.state;
//        cell.label.numberOfLines = model.numberOfLines;
//        CGSize size = [cell.label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 15, MAXFLOAT)];
        return 160;
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
        static NSString *  DeviceRealView = @"CellId";
        //自定义cell类
        DeviceMaintainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceRealView];
        
        if (!cell){
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSMutableDictionary * nsmuTab = [self.dataSource objectAtIndex:indexPath];
        
        NSString * care_time = [nsmuTab objectForKey:@"care_time"];
          NSString * run_total_time = [self getIntegerValue:[nsmuTab objectForKey:@"run_total_time"]];
         NSString * remarks = [nsmuTab objectForKey:@"remarks"];
         NSString * content = [nsmuTab objectForKey:@"content"];
        NSString * care_userName = @"";
        if ([nsmuTab objectForKey:@"care_userName"]) {
            care_userName = [nsmuTab objectForKey:@"care_userName"];
        }
        
        cell.byTime.text = [self getPinjieNSString:@"保养时间：" :care_time];
        cell.byPerson.text = [self getPinjieNSString:@"保养人：" :care_userName];
        cell.workTime.text = [self getPinjieNSString:@"工作时长：" :[self getPinjieNSString:care_userName :@"小时"]];
        cell.byContent.text = [self getPinjieNSString:@"工作内容：" :content];
        cell.byRemark.text = [self getPinjieNSString:@"备注：" :remarks];
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
        
        [self getSelectBusDeviceCareNotesByPage];
        
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator startAnimating];
    
    // 加载下一页
    //    [self loadNextPage];
}

#pragma mark - ======== XLHTableViewDelegate ========
//
//- (void)tableViewCell:(XLHTableViewCell *)cell model:(XLHModel *)model numberOfLines:(NSInteger)numberOfLines {
//    model.numberOfLines = numberOfLines;
//    if (numberOfLines == 0) {
//        model.state = XLHOpenState;
//    } else {
//        model.state = XLHCloseState;
//    }
//    [self.tableView reloadData];
//}

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

// 保养第一次获取周期
-(void)getBusDeviceCareDate{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
   
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:self.deviceId forKey:@"device_id"];
    [diction setValue:ptoken forKey:@"token"];
   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :getBusDeviceCareDate];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
       // id myResult =  [ self getMyResult:responseObject];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self setBusDeviceCareDate:responseObject];
        }
        if ([responseObject isKindOfClass:[NSString class]]) {
            //[self showToastTwo:myResult];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setBusDeviceCareDate:(NSMutableDictionary *)dictionary{
    if (![[dictionary allKeys] containsObject:@"data"]) {
        return;
    }
      self.firstByDate =  [dictionary objectForKey:@"data"];
    
}


@end

//
//  DeviceDataMonitorViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/6/4.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "DeviceDataMonitorViewController.h"
#import "LowerControlViewControllerFour.h"



@interface DeviceDataMonitorViewController ()

@end

@implementation DeviceDataMonitorViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceDataMonitorViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DeviceDataMonitorViewController"];
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
    _personNib = [UINib nibWithNibName:@"DataMonitorTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    [self dataSource];
    
    self.alarmLabel.numberOfLines = 0;//表示label可以多行显示
    self.alarmLabel.text = @"当日报\n警次数";
    self.alarmLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.faultLabel.numberOfLines = 0;//表示label可以多行显示
    self.faultLabel.text = @"当日故\n障次数";
    self.faultLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self setupRefreshData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _hasMore = true;
    startRow = 1;
    
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getDeviceList];
            
            //            [self requestData:1];
            // [weakSelf.mTableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}


// 获取项目列表
-(void)getDeviceList{
    
    NSMutableDictionary * dicnary = [self queryData];
     NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:self.projectId forKey:@"device_id"];
    [diction setValue:@(20) forKey:@"pageSize"];
    [diction setValue:@(startRow) forKey:@"pageNum"];
     [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectDevicePointData4MonitorByPage];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        total =   [[responseObject objectForKey:@"total"] intValue];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setDeviceList:myResult];
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
-(void)setDeviceList:(NSMutableArray *)nsArr{
     NSMutableString *printStr2 = [[NSMutableString alloc] init];
    for (NSMutableDictionary * nsmuTab in nsArr) {
        [self.dataSource addObject:nsmuTab];
        
          NSString * point_key =  [nsmuTab objectForKey:@"point_key"];
       [printStr2 appendFormat:@"%@", [self getPinjieNSString:point_key:@","]];
    }
    if ([printStr2 length] > 0) {
       printStr2 =  [printStr2 substringToIndex:[printStr2 length] - 1];
    }
    self.pointKey = [NSString stringWithString:printStr2];
      [self.tableView reloadData];
    
    
    //你的操作
    [self loadNextPage];
    
   [self initWebSocket];
}

-(void)setRefresh:(NSString *)projectId{
    self.projectId = projectId;
    [self clearData];
    [self getDeviceList];
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
        //        UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        //        if ([cell isKindOfClass:[AlarmItemTableViewCell class]]) {
        //            AlarmItemTableViewCell * alarmItemCell = cell;
        //            int myHeight = alarmItemCell.bounds.size.height;
        //             return myHeight;
        //        }
        return 50;
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
        static NSString *  DataMonitortCellView = @"CellId";
        //自定义cell类
        DataMonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DataMonitortCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
//        cell.alarmValue.layer.backgroundColor = [UIColor colorWithRed:253/255.0 green:208/255.0 blue:0/255.0 alpha:1].CGColor;
//        cell.alarmValue.layer.cornerRadius = 5;
//
//        cell.faultValue.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:17/255.0 blue:34/255.0 alpha:1].CGColor;
//        cell.faultValue.layer.cornerRadius = 5;
        
//        cell.alarmValue.textColor = [UIColor colorWithRed:253/255.0 green:208/255.0 blue:0/255.0 alpha:1];
//        cell.faultValue.textColor = [UIColor colorWithRed:243/255.0 green:17/255.0 blue:34/255.0 alpha:1];
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * dataCode =  [dicOne objectForKey:@"data_code"];
        NSString * dataName =  [dicOne objectForKey:@"data_name"];
        int lower_control = [[dicOne objectForKey:@"lower_control"] intValue];
        NSString * data_type = [dicOne objectForKey:@"data_type"];
        double valueDou = [[dicOne objectForKey:@"fact_value"] intValue];
//         NSString * value = [NSString stringWithFormat: @"%.1lf", valueDou];
             int dataType = [data_type intValue];
        NSString *value = @"";
        if (![[dicOne allKeys] containsObject:@"fact_value"]) {
            value = @"";
        }else{
            if (dataType == 0) {
                value = [NSString stringWithFormat: @"%.1lf", valueDou];
            }else{
                int myInt = (int)valueDou;
                 value = [NSString stringWithFormat:@"%d", myInt];
            }
        }
       
//        NSString * value = [self doubleToNSString:valueDou];
        NSString * unit =  [dicOne objectForKey:@"unit"];
        
        NSString * todayAlarmAmounts =  [self getIntegerValue:[dicOne objectForKey:@"warn_total"]];
        NSString * todayErrorAmounts = [self getIntegerValue:[dicOne objectForKey:@"error_total"]];
        
        cell.descTitle.text = [self getPinjieNSString:@"  ":dataName];
      
        cell.bjUnit.text = unit;
        cell.alarmValue.text = todayAlarmAmounts;
        cell.faultValue.text = todayErrorAmounts;
        
         cell.blValue.text = value;
        
        if (lower_control == 0) {
            cell.xiakLabel.text = @"";
        }else{
              cell.xiakLabel.text = @"下控";
        }
        
        
       //   NSString * data_type =  [dicOne objectForKey:@"data_type"];
        NSString * device_id =  [dicOne objectForKey:@"device_id"];
         NSString * data_id =  [dicOne objectForKey:@"data_id"];
        
        cell.xiakLabel.deviceId = device_id;
         cell.xiakLabel.dataId = data_id;
         cell.xiakLabel.data_type = data_type;
        
        NSString *user_id = [NSString stringWithFormat:@"%d", indexPath.row];
        cell.xiakLabel.positionStr = user_id;
        
        cell.xiakLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [cell.xiakLabel addGestureRecognizer:labelTapGestureRecognizer];
        
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
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    ProLabel *label=(ProLabel*)recognizer.view;
    NSString * textLabel =  label.text;
    if ([self isBlankString:textLabel]) {
        return;
    }
    NSString * deviceId =  label.deviceId;
    NSString * dataId =  label.dataId;
    NSString * data_type =  label.data_type;  //data_type  0 浮点数 1 整形  2 布尔类型
    NSString * positionStr = label.positionStr;
    
    if ([self getNSStringEqual:data_type:@"0"]) {
        LowerControlViewControllerThree * controller = [LowerControlViewControllerThree new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSString *passedValue){
            
            NSMutableDictionary * dicnary = [self queryData];
            NSString *ptoken = [dicnary objectForKey:@"ptoken"];
            
            NSMutableDictionary * diction = [NSMutableDictionary dictionary];
            [diction setValue:ptoken forKey:@"token"];
            [diction setValue:deviceId forKey:@"object_id"];
            [diction setValue:dataId forKey:@"data_id"];
            [diction setValue:data_type forKey:@"data_type"];
            [diction setValue:passedValue forKey:@"control_value"];
            
            [self getSendControl2Box:diction:positionStr];
            
        };
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        controller.providesPresentationContextTransitionStyle = YES;
        
        controller.definesPresentationContext = YES;
        
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
    }
    if ([self getNSStringEqual:data_type:@"1"]) {
        LowerControlViewControllerTwo * controller = [LowerControlViewControllerTwo new];
        //赋值Block，并将捕获的值赋值给UILabel
            controller.returnValueBlock = ^(NSString *passedValue){
                
                NSMutableDictionary * dicnary = [self queryData];
                NSString *ptoken = [dicnary objectForKey:@"ptoken"];
                
                NSMutableDictionary * diction = [NSMutableDictionary dictionary];
                [diction setValue:ptoken forKey:@"token"];
                [diction setValue:deviceId forKey:@"object_id"];
                [diction setValue:dataId forKey:@"data_id"];
                [diction setValue:data_type forKey:@"data_type"];
                [diction setValue:passedValue forKey:@"control_value"];
                
                [self getSendControl2Box:diction:positionStr];
               
            };
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        controller.providesPresentationContextTransitionStyle = YES;
        
        controller.definesPresentationContext = YES;
        
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
    }
    if ([self getNSStringEqual:data_type:@"2"]) {
        LowerControlViewController * controller = [LowerControlViewController new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSString *passedValue){
            
            NSMutableDictionary * dicnary = [self queryData];
            NSString *ptoken = [dicnary objectForKey:@"ptoken"];
            
            NSMutableDictionary * diction = [NSMutableDictionary dictionary];
            [diction setValue:ptoken forKey:@"token"];
            [diction setValue:deviceId forKey:@"object_id"];
            [diction setValue:dataId forKey:@"data_id"];
            [diction setValue:data_type forKey:@"data_type"];
            [diction setValue:passedValue forKey:@"control_value"];
            
            [self getSendControl2Box:diction:positionStr];
            
        };
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
    }
    if ([self getNSStringEqual:data_type:@"3"]) {
        LowerControlViewControllerFour * controller = [LowerControlViewControllerFour new];
        //赋值Block，并将捕获的值赋值给UILabel
        controller.returnValueBlock = ^(NSString *passedValue){
            
            NSMutableDictionary * dicnary = [self queryData];
            NSString *ptoken = [dicnary objectForKey:@"ptoken"];
            
            NSMutableDictionary * diction = [NSMutableDictionary dictionary];
            [diction setValue:ptoken forKey:@"token"];
            [diction setValue:self.projectId forKey:@"object_id"];
            [diction setValue:dataId forKey:@"data_id"];
            [diction setValue:data_type forKey:@"data_type"];
            [diction setValue:passedValue forKey:@"control_value"];
            
            [self getSendControl2Box:diction:positionStr];
            
        };
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        controller.providesPresentationContextTransitionStyle = YES;
        
        controller.definesPresentationContext = YES;
        
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
        [self presentViewController:controller animated:YES completion:nil];
    }
 
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
    
//    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
//    NSString * dataId = [self getIntegerValue: [dicOne objectForKey:@"data_id"]];
//    NSString * device_id = [self getIntegerValue: [dicOne objectForKey:@"device_id"]];
//    NSString * data_name = [dicOne objectForKey:@"data_name"];
    
   
}
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
        [self getDeviceList];
    }
}

-(void)clearData{
    [self.dataSource removeAllObjects];
    startRow = 1;
    _hasMore = true;
    
}

-(void)loadNextPage{
    
    //    [ProgressHUD dismiss];
    
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

//   提交下控
-(void)getSendControl2Box:(NSMutableDictionary *)diction:(NSString *)positionStr{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :object_sendControl2Box];
    
    NSMutableDictionary * queryDic = [self queryData];
    NSString *ptoken = [queryDic objectForKey:@"ptoken"];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
           
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self setSendControl2Box:responseObject:positionStr:diction];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setSendControl2Box:(NSMutableDictionary *) responseObject:(NSString *)positionStr:(NSMutableDictionary *)diction{
    
    NSString * control_value = [diction objectForKey:@"control_value"];
  
   NSString * message =  [responseObject objectForKey:@"message"];
    [self showToast:message];
    
    int  myCode  = [[responseObject objectForKey:@"code"] intValue];
    if (myCode == 200) {
        int position = [positionStr intValue];
        
        NSMutableDictionary * dicOne  =   [self.dataSource objectAtIndex:position];
     
          NSMutableDictionary * temtOne = [NSMutableDictionary dictionary];
        for(NSString *key in dicOne){
            if ([self getNSStringEqual:key:@"fact_value"]) {
                 [temtOne setValue:control_value forKey:@"fact_value"];
            }else{
                  [temtOne setValue:dicOne[key] forKey:key];
            }
        }
        [self.dataSource replaceObjectAtIndex:position withObject:temtOne];
    
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:position inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidDisappear:animated];
    
    if (nil !=  self.socket) {
        [self.socket close];
           self.socket = nil;
    }
}

//初始化 WebSocket
- (void)initWebSocket{
    if (self.socket) {
        return;
    }
    
    if ([self isBlankString:self.pointKey]) {
        return;
    }
    
    if (nil !=  self.socket) {
        [self.socket close];
           self.socket = nil;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * websocketData = [defaults objectForKey:@"websocketData"];
    
    websocketData =   [self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:websocketData:@"/socketServer/"]:self.projectId]:[self getPinjieNSString:@"-":[self getTimestampFromTime]]];
     NSLog(@"url---：%@",websocketData);
    //Url
    NSURL *url = [NSURL URLWithString:websocketData];
    //请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //初始化请求`
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    //代理协议`
    self.socket.delegate = self;
    // 实现这个 SRWebSocketDelegate 协议啊`
    //直接连接`
    [self.socket open];    // open 就是直接连接了
}

#pragma mark -- SRWebSocketDelegate
//收到服务器消息是回调
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到服务器返回消息：%@",message);
    
    NSMutableArray * nsmuArr =  [NSMutableArray array];
    if ([message isKindOfClass:[NSString class]]) {
        nsmuArr =  [self dictionaryWithJsonString:message];
    }else{
        nsmuArr = (NSMutableArray *)message;
    }
    
    if (nil != nsmuArr && [nsmuArr count] > 0) {
        for(int i = 0;i<[self.dataSource count];i++){
              NSMutableDictionary * myDicItem =  [self.dataSource objectAtIndex:i];
            NSString * curPointKey =  [myDicItem objectForKey:@"point_key"];
            
            for (NSMutableDictionary *  nsmuDic in nsmuArr) {
                  NSString * point_key =  [nsmuDic objectForKey:@"pointKey"];
                if(![self isBlankString:point_key] && [point_key containsString:curPointKey]){
                    // fact_value
                    
                      NSString * valueStr =  [nsmuDic objectForKey:@"value"];
                   
                    NSMutableDictionary * repreDic = [NSMutableDictionary dictionary];
                    for(NSString *key in myDicItem)
                    {
                        if ([self getNSStringEqual:key:@"fact_value"]) {
                            [repreDic setValue:valueStr forKey:@"fact_value"];
                        }else{
                             [repreDic setValue:myDicItem[key] forKey:key];
                        }
                       // NSLog(@"key:%@ value:%@",key,dictFive[key]);
                    }
                    
                     [self.dataSource replaceObjectAtIndex:i withObject:repreDic];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
}

//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"连接成功，可以立刻登录你公司后台的服务器了，还有开启心跳");
//    [self initHeart];   //开启心跳
    
    if (self.socket != nil) {
        // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
        if (self.socket.readyState == SR_OPEN) {
            
            NSString * jsonString = [self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:@"datas;":self.projectId]:@"-"]:[self getTimestampFromTime]]:@";"]:self.pointKey];
         NSLog(@"---%@",jsonString);
            [self.socket send:jsonString];  //发送数据包
            
        } else if (self.socket.readyState == SR_CONNECTING) {
            NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
            // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
            // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
            // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
            // 代码有点长，我就写个逻辑在这里好了
            
        } else if (self.socket.readyState == SR_CLOSING || self.socket.readyState == SR_CLOSED) {
            // websocket 断开了，调用 reConnect 方法重连
        }
    } else {
        NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
        NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
    }
}

//连接失败的回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
    //关闭心跳包
    [webSocket close];
    
    [self reConnect];
}

//连接断开的回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Close");
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Pong");
}

//保活机制  探测包
- (void)initHeart{
//    __weak typeof(self) weakSelf = self;
//    _heatBeat = [NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf.socket send:@"heart"];
//        NSLog(@"已发送");
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:_heatBeat forMode:NSRunLoopCommonModes];
}

//断开连接时销毁心跳
- (void)destoryHeart{
    
}

- (void)reConnect{
    //每隔一段时间重连一次
    //规定64不在重连,2的指数级
//    if (_reConnectTime > 60) {
//        return;
//    }
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.socket = nil;
//        [self initWebSocket];
//    });
//
//    if (_reConnectTime == 0) {
//        _reConnectTime = 2;
//    }else{
//        _reConnectTime *= 2;
//    }
}


@end

//
//  DeviceRealEmpiricViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/6/24.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "DeviceRealEmpiricViewController.h"
#import "WRNavigationBar.h"
#import <UMCommon/MobClick.h>

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 500


@interface DeviceRealEmpiricViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, strong) UILabel *labelThree;
@property (nonatomic, strong) UILabel *labelFour;
@property (nonatomic, strong) UILabel *labelFive;
@property (nonatomic, strong) UILabel *labelSix;
@property (nonatomic, strong) UILabel *labelEight;
@property (nonatomic, strong) UILabel *labelNine;
@property (nonatomic, strong) UILabel *labelTen;
@property (nonatomic, strong) UILabel *labelEleven;
@property (nonatomic, strong) UILabel *labelServen;
@property (nonatomic, strong) UILabel *labelTwelve;
@property (nonatomic, strong) UILabel *labelThirteen;
@property (nonatomic, strong) UILabel *labelFourteen;
@property (nonatomic, strong) UILabel *labelFifteen;
@property (nonatomic, strong) UILabel *labelSixteen;


@property (nonatomic, strong) UILabel *labelViewOne;
@property (nonatomic, strong) UILabel *labelViewTwo;
@property (nonatomic, strong) UILabel *labelViewThree;
@property (nonatomic, strong) UILabel *labelViewFour;
@property (nonatomic, strong) UILabel *labelViewFive;
@property (nonatomic, strong) UILabel *labelViewSix;
@property (nonatomic, strong) UILabel *labelViewSenven;
@property (nonatomic, strong) UILabel *labelViewEight;
@property (nonatomic, strong) UILabel *labelViewNine;
@property (nonatomic, strong) UILabel *labelViewTen;


@end

@implementation DeviceRealEmpiricViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceRealEmpiricViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DeviceRealEmpiricViewController"];
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
    self.navigationItem.title = @"历史经验";
    
        self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    
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
//    _personNib = [UINib nibWithNibName:@"EmpiricViewTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    

    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于
    _personNib = [UINib nibWithNibName:@"FaultViewTableViewCell" bundle:nil]; //这句话就相当于
    
    [self dataSource];
    
      self.tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:255/255.0 alpha:1];
    
    self.tableView.tableHeaderView = self.topView;
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
   
    [self.tableView reloadData];
}
-(void)viewWillLayoutSubviews{

}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tabelview {
    
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
        static NSString * DeviceRealView = @"CallId";
        //自定义cell类
        FaultViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceRealView];
        
        if (!cell){
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        cell.okBtn.layer.cornerRadius = 5;
        cell.okBtn.layer.masksToBounds = YES;
        
        
        //        //得到view的遮罩路径
        //        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.faultBg.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
        //        //创建 layer
        //        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //        maskLayer.frame = cell.faultBg.bounds;
        //        //赋值
        //        maskLayer.path = maskPath.CGPath;
        //        cell.faultBg.layer.mask = maskLayer;
        
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * msg_id =  [self getIntegerValue:[dicOne objectForKey:@"msg_id"]] ;
        NSString * alarm_name =  [dicOne objectForKey:@"alarm_name"];
        NSString * alarm_desc =  [dicOne objectForKey:@"alarm_desc"];
        NSString * create_time =  [dicOne objectForKey:@"create_time"];
        NSString * device_name = [dicOne objectForKey:@"device_name"];
        
        NSString * work_status =  [self getIntegerValue:[dicOne objectForKey:@"work_status"]] ;
        
        if ([self getNSStringEqual:work_status:@"1"]) {
            [cell.okBtn setTitle:@"已确认" forState:UIControlStateNormal];
        }else{
            [cell.okBtn setTitle:@"报警确认" forState:UIControlStateNormal];
        }
        cell.okBtn.workStatus = work_status;
        
//        if (isFault == 0) {
//            [cell.okBtn setHidden:YES];
//        }
        
        cell.okBtn.userId = msg_id;
        cell.okBtn.createUserId =create_time;
        [cell.okBtn addTarget:self action:@selector(setOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.alarmName.text = [self getPinjieNSString:@"对象名称：":device_name];
        cell.alarmDate.text = [self getPinjieNSString:@"报警时间：":create_time];
        
        cell.alarmDesc.text = [self getPinjieNSString:@"报警描述：":alarm_desc];
        cell.alarmTitle.text = alarm_name;
        
        cell.detailsButton.tag = indexPath.row;
        [cell.detailsButton addTarget:self action:@selector(setUpdateList:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (refreshPosition == indexPath.row) {
//           [cell.detailsButton setTitle:@"【返回】" forState:UIControlStateNormal];
//             cell.alarmDesc.numberOfLines = 0;
//        }else{
//             [cell.detailsButton setTitle:@"【详情】" forState:UIControlStateNormal];
//             cell.alarmDesc.numberOfLines = 1;
//        }
        
        
        return cell;
    }
    
    // 加载更多
    static NSString * noDataLoadMore = @"CellIdentifierLoadMore";
    
    NoDateTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
    if (!loadCell)
    {
        loadCell = [_nodataNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
    }
  
    return loadCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 1 松开手选中颜色消失
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }
    
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
    //    AlartDetailsViewController * alartDetail = [[AlartDetailsViewController alloc] init];
    //    alartDetail.mutabDic = dicOne;
    //    alartDetail.isHistory = @"yes";
    //    [self.navigationController pushViewController:alartDetail  animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
    
    
    //    CGFloat offsetY = scrollView.contentOffset.y;
    //    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    //    {
    //        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
    //        [self wr_setNavBarBackgroundAlpha:alpha];
    //        [self wr_setNavBarTintColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    //        [self wr_setNavBarTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    //        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    //    }
    //    else
    //    {
    //        [self wr_setNavBarBackgroundAlpha:0];
    //        [self wr_setNavBarTintColor:[UIColor greenColor]];
    //        [self wr_setNavBarTitleColor:[UIColor yellowColor]];
    //        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    //    }
}
- (UIView *)topView
{
    if (_topView == nil) {
        //  _topView = [[UIView alloc]init];
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT, SCREEN_WIDTH, IMAGE_HEIGHT)];
        _topView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        [self getUpData];
    }
    return _topView;
}

// 获取详情
-(void)getUpData{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    int msgId =   [self.msg_id intValue];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:@(msgId) forKey:@"msg_id"];
    [diction setValue:@(0) forKey:@"is_his"];
     [diction setValue:self.create_time forKey:@"create_time"];
     [diction setValue:ptoken forKey:@"token"];
//      [diction setValue:module_type_doctor forKey:@"module_type"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :deviceselectHisExperienceByMsgId];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setLabelViews:myResult];
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

-(void)setLabelViews:(NSMutableDictionary *)nsArr{
    NSString * alarm_name = [nsArr objectForKey:@"alarm_name"];
    NSString * create_time = [nsArr objectForKey:@"alarm_time"];
    create_time = [self getTimestamp:create_time];
    NSString * fact_value = @"";
    if ([self getKeyIsNoValueIsNull:nsArr:@"alarm_value"]) {
        fact_value =  [self getIntegerValue:[nsArr objectForKey:@"alarm_value"]];
    }
  
    NSString * device_name = [nsArr objectForKey:@"object_name"];
    NSString * project_name = [nsArr objectForKey:@"project_name"];
    NSString * alarm_desc = [nsArr objectForKey:@"alarm_desc"];
     int alarm_level = [[nsArr objectForKey:@"alarm_level"] intValue];
      NSString * confirm_time = [nsArr objectForKey:@"confirm_time"];
      NSString * user_name = [nsArr objectForKey:@"user_name"];
     int  his_rule = [[nsArr objectForKey:@"his_rule"] intValue];
    NSString * alarm_info_value = @"";
    if ([self getKeyIsNoValueIsNull:nsArr:@"alarm_info_value"]) {
        alarm_info_value =  [nsArr objectForKey:@"alarm_info_value"];
    }
    NSString * alarm_info_express = @"";
    if ([self getKeyIsNoValueIsNull:nsArr:@"alarm_info_express"]) {
        alarm_info_express =  [nsArr objectForKey:@"alarm_info_express"];
    }
    NSString * alarm_reason = @"";
    if ([self getKeyIsNoValueIsNull:nsArr:@"alarm_reason"]) {
        alarm_reason =  [nsArr objectForKey:@"alarm_reason"];
    }
    NSString * press_method = @"";
    if ([self getKeyIsNoValueIsNull:nsArr:@"press_method"]) {
        press_method =  [nsArr objectForKey:@"press_method"];
    }
    // 首行
    if (self.labelOne == nil) {
        self.labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 50)];
        self.labelOne.text = @"报警详情";
        self.labelOne.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelOne.font = [UIFont systemFontOfSize:16];
        [self.topView addSubview:self.labelOne];
    }
    if (self.labelTwo == nil) {
        self.labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 5)];
        self.labelTwo.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1];
        [self.topView addSubview:self.labelTwo];
    }
    // 第一行
    if (self.labelThree == nil) {
        
    UILabel   * labelThreeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 80, 35)];
        labelThreeName.text = @"设备名称";
        labelThreeName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelThreeName.font = [UIFont systemFontOfSize:14];
      
        [self.topView addSubview:labelThreeName];
        
        self.labelThree = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, SCREEN_WIDTH - 80, 35)];
        self.labelThree.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelThree.font = [UIFont systemFontOfSize:14];
//        [self setAttributeStringForPriceLabel:self.labelThree text:device_name];
        [self.topView addSubview:self.labelThree];
    }
       self.labelThree.text = device_name;
    
    if (self.labelViewOne == nil) {
        self.labelViewOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 0.5)];
        self.labelViewOne.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewOne];
    }
     // 第二行
    if (self.labelFour == nil) {
        
        UILabel   * labelFourName = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 80, 35)];
        labelFourName.text = @"报警名称";
        labelFourName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelFourName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelFourName];
        
        self.labelFour = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, SCREEN_WIDTH - 80, 35)];
       
        self.labelFour.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelFour.font = [UIFont systemFontOfSize:14];
//         [self setAttributeStringForPriceLabel:self.labelFour text:alarm_name];
        [self.topView addSubview:self.labelFour];
    }
     self.labelFour.text = alarm_name;
    if (self.labelViewTwo == nil) {
        self.labelViewTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 0.5)];
        self.labelViewTwo.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewTwo];
    }
     // 第三行
    if (self.labelFive == nil) {
        
        UILabel   * labelFiveName = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 80, 35)];
        labelFiveName.text = @"报警时间";
        labelFiveName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelFiveName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelFiveName];
        
        self.labelFive = [[UILabel alloc] initWithFrame:CGRectMake(80, 125, SCREEN_WIDTH - 80, 35)];
      
        self.labelFive.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelFive.font = [UIFont systemFontOfSize:14];
//          [self setAttributeStringForPriceLabel:self.labelFive text:create_time];
        [self.topView addSubview:self.labelFive];
    }
      self.labelFive.text = create_time;
    if (self.labelViewThree == nil) {
        self.labelViewThree = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 0.5)];
        self.labelViewThree.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewThree];
    }
     // 第四行
    if (self.labelSix == nil) {
        
        UILabel   * labelSixName = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 80, 35)];
        labelSixName.text = @"报警级别";
        labelSixName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelSixName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelSixName];
        
        self.labelSix = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, SCREEN_WIDTH - 80, 35)];
     
        self.labelSix.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelSix.font = [UIFont systemFontOfSize:14];
       
        [self.topView addSubview:self.labelSix];
    }
    NSString * levelNstr = @"";
    if (alarm_level == 1) {
        levelNstr = @"故障";
    }else{
        levelNstr = @"告警";
    }
      self.labelSix.text = levelNstr;
//     [self setAttributeStringForPriceLabel:self.labelSix text:levelNstr];
    
    if (self.labelViewFour == nil) {
        self.labelViewFour = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, SCREEN_WIDTH, 0.5)];
        self.labelViewFour.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewFour];
    }
     // 第五行
    if (self.labelEight == nil) {
        
        UILabel   * labelEightName = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, 80, 35)];
        labelEightName.text = @"确认时间";
        labelEightName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelEightName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelEightName];
        
        self.labelEight = [[UILabel alloc] initWithFrame:CGRectMake(80, 195, SCREEN_WIDTH - 80, 35)];
      
        self.labelEight.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelEight.font = [UIFont systemFontOfSize:14];
//          [self setAttributeStringForPriceLabel:self.labelEight text:confirm_time];
        [self.topView addSubview:self.labelEight];
    }
      self.labelEight.text = confirm_time;
    if (self.labelViewFive == nil) {
        self.labelViewFive = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 0.5)];
        self.labelViewFive.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewFive];
    }
     // 第六行
    if (self.labelEleven == nil) {
        
        UILabel   * labelElevenName = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 80, 35)];
        labelElevenName.text = @"确认人";
        labelElevenName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelElevenName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelElevenName];
        
        self.labelEleven = [[UILabel alloc] initWithFrame:CGRectMake(80, 230, SCREEN_WIDTH - 80, 35)];
     
        self.labelEleven.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelEleven.font = [UIFont systemFontOfSize:14];
//         [self setAttributeStringForPriceLabel:self.labelEleven text:user_name];
        [self.topView addSubview:self.labelEleven];
    }
       self.labelEleven.text = user_name;
    if (self.labelViewSix == nil) {
        self.labelViewSix = [[UILabel alloc] initWithFrame:CGRectMake(0, 265, SCREEN_WIDTH, 0.5)];
        self.labelViewSix.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewSix];
    }
     // 第七行
    if (self.labelTwelve == nil) {
        
        UILabel   * labelTwelveName = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 80, 35)];
        labelTwelveName.text = @"报警值";
        labelTwelveName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelTwelveName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelTwelveName];
        
        self.labelTwelve = [[UILabel alloc] initWithFrame:CGRectMake(80, 265, SCREEN_WIDTH - 80, 35)];
    
        self.labelTwelve.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelTwelve.numberOfLines = 0; ///相当于不限制行数
        self.labelTwelve.textAlignment = NSTextAlignmentLeft;
        self.labelTwelve.lineBreakMode = NSLineBreakByCharWrapping;
     //   [self.labelTwelve sizeToFit];
        self.labelTwelve.font = [UIFont systemFontOfSize:14];
//          [self setAttributeStringForPriceLabel:self.labelTwelve text:alarm_info_value];
        [self.topView addSubview:self.labelTwelve];
    }
        self.labelTwelve.text = alarm_info_value;
    if (self.labelViewSenven == nil) {
        self.labelViewSenven = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 0.5)];
        self.labelViewSenven.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewSenven];
    }
     // 第八行
    if (self.labelThirteen == nil) {
        
        UILabel   * labelThirteenName = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 80, 35)];
        labelThirteenName.text = @"报警提醒";
        labelThirteenName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelThirteenName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelThirteenName];
        
        self.labelThirteen = [[UILabel alloc] initWithFrame:CGRectMake(80, 300, SCREEN_WIDTH - 80, 35)];
      
        self.labelThirteen.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelThirteen.numberOfLines = 0; ///相当于不限制行数
        self.labelThirteen.textAlignment = NSTextAlignmentLeft;
        self.labelThirteen.lineBreakMode = NSLineBreakByCharWrapping;
        //   [self.labelTwelve sizeToFit];
        self.labelThirteen.font = [UIFont systemFontOfSize:14];
     
        [self.topView addSubview:self.labelThirteen];
    }
    NSString * ruleNtr = @"";
    if (his_rule == 1) {
        ruleNtr = @"确认";
    }
    if (his_rule == 2) {
        ruleNtr = @"确认并恢复";
    }
    if (his_rule == 3) {
        ruleNtr = @"恢复";
    }
//       [self setAttributeStringForPriceLabel:self.labelThirteen text:ruleNtr];
     self.labelThirteen.text = ruleNtr;
    
    if (self.labelViewEight == nil) {
        self.labelViewEight = [[UILabel alloc] initWithFrame:CGRectMake(0, 335, SCREEN_WIDTH, 0.5)];
        self.labelViewEight.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewEight];
    }
     // 第九行
    if (self.labelFourteen == nil) {
        
        UILabel   * labelFourteenName = [[UILabel alloc] initWithFrame:CGRectMake(10, 335, 80, 35)];
        labelFourteenName.text = @"报警条件";
        labelFourteenName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelFourteenName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelFourteenName];
        
        self.labelFourteen = [[UILabel alloc] initWithFrame:CGRectMake(80, 335, SCREEN_WIDTH - 80, 35)];
      
        self.labelFourteen.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelFourteen.numberOfLines = 0; ///相当于不限制行数
        self.labelFourteen.textAlignment = NSTextAlignmentLeft;
        self.labelFourteen.lineBreakMode = NSLineBreakByCharWrapping;
        //   [self.labelTwelve sizeToFit];
        self.labelFourteen.font = [UIFont systemFontOfSize:14];
//        [self setAttributeStringForPriceLabel:self.labelFourteen text:alarm_desc];
        [self.topView addSubview:self.labelFourteen];
    }
      self.labelFourteen.text = alarm_desc;
    if (self.labelViewNine == nil) {
        self.labelViewNine = [[UILabel alloc] initWithFrame:CGRectMake(0, 370, SCREEN_WIDTH, 0.5)];
        self.labelViewNine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewNine];
    }
     // 第十行
    if (self.labelFifteen == nil) {
        
        UILabel   * labelFifteeneName = [[UILabel alloc] initWithFrame:CGRectMake(10, 370, 80, 35)];
        labelFifteeneName.text = @"报警原因";
        labelFifteeneName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelFifteeneName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelFifteeneName];
        
        self.labelFifteen = [[UILabel alloc] initWithFrame:CGRectMake(80, 370, SCREEN_WIDTH - 80, 35)];
      
        self.labelFifteen.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelFifteen.numberOfLines = 0; ///相当于不限制行数
        self.labelFifteen.textAlignment = NSTextAlignmentLeft;
        self.labelFifteen.lineBreakMode = NSLineBreakByCharWrapping;
        //   [self.labelTwelve sizeToFit];
        self.labelFifteen.font = [UIFont systemFontOfSize:14];
//        [self setAttributeStringForPriceLabel:self.labelFifteen text:alarm_reason];
        [self.topView addSubview:self.labelFifteen];
    }
      self.labelFifteen.text = alarm_reason;
    if (self.labelViewTen == nil) {
        self.labelViewTen = [[UILabel alloc] initWithFrame:CGRectMake(0, 405, SCREEN_WIDTH, 0.5)];
        self.labelViewTen.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.topView addSubview:self.labelViewTen];
    }
     // 第十一行
    if (self.labelSixteen == nil) {
        
        UILabel   * labelSixteenName = [[UILabel alloc] initWithFrame:CGRectMake(10, 405, 80, 35)];
        labelSixteenName.text = @"处理方法";
        labelSixteenName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        labelSixteenName.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:labelSixteenName];
        
        self.labelSixteen = [[UILabel alloc] initWithFrame:CGRectMake(80, 405, SCREEN_WIDTH - 80, 35)];
    
        self.labelSixteen.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelSixteen.numberOfLines = 0; ///相当于不限制行数
        self.labelSixteen.textAlignment = NSTextAlignmentLeft;
        self.labelSixteen.lineBreakMode = NSLineBreakByCharWrapping;
        //   [self.labelTwelve sizeToFit];
        self.labelSixteen.font = [UIFont systemFontOfSize:14];
//        [self setAttributeStringForPriceLabel:self.labelSixteen text:press_method];
        [self.topView addSubview:self.labelSixteen];
    }
        self.labelSixteen.text = press_method;
    if (self.labelNine == nil) {
        self.labelNine = [[UILabel alloc] initWithFrame:CGRectMake(0, 440, SCREEN_WIDTH, 10)];
        self.labelNine.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1];
        [self.topView addSubview:self.labelNine];
    }
    
    // 尾行
    if (self.labelTen == nil) {
        self.labelTen = [[UILabel alloc] initWithFrame:CGRectMake(20, 450, SCREEN_WIDTH, 50)];
        self.labelTen.text = @"历史记录";
        self.labelTen.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.labelTen.font = [UIFont systemFontOfSize:16];
        [self.topView addSubview:self.labelTen];
    }
    if (self.labelServen == nil) {
        self.labelServen = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, SCREEN_WIDTH, 5)];
        self.labelServen.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1];
        [self.topView addSubview:self.labelServen];
    }
    
    NSMutableArray * itemsList = [nsArr objectForKey:@"itemsList"];
//    for (NSMutableDictionary * nsmuTab in itemsList) {
//        XLHModel *model = [[XLHModel alloc]init];
//        model.title =  [self getPinjieNSString:[self getPinjieNSString:@"报警值：":alarm_info_value]:alarm_info_express] ;
//        model.careTime = create_time;
//        model.carePerson = user_name;
//        model.careWorkTimes = alarm_reason;
//        model.careRemares = press_method;
//        model.numberOfLines = 1;
//        model.state = XLHNormalState;
//        [self.dataSource addObject:model];
//    }
    
    [self.tableView reloadData];
    
}

//- (void)setAttributeStringForPriceLabel:(UILabel *)label text:(NSString *)text
//{
//
//    if ([self isBlankString:text]) {
//        text = @"";
//    }
//
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString
//                                              alloc] initWithString:text];
//    NSUInteger length = [text length];
//    NSMutableParagraphStyle *
//    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.tailIndent = -10; //设置与尾部的距离
//    style.alignment = NSTextAlignmentRight;//靠右显示
//    [attrString addAttribute:NSParagraphStyleAttributeName value:style
//                       range:NSMakeRange(0, length)];
//    label.attributedText = attrString;
//}
//
//#pragma mark - ======== XLHTableViewDelegate ========
//
//- (void)tableViewCell:(HisjyTableViewCell *)cell model:(XLHModel *)model numberOfLines:(NSInteger)numberOfLines {
//    model.numberOfLines = numberOfLines;
//    if (numberOfLines == 0) {
//        model.state = XLHOpenState;
//    } else {
//        model.state = XLHCloseState;
//    }
//    [self.tableView reloadData];
//}

@end

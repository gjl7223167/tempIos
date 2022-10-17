//
//  ApplyTimeViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/22.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "ApplyTimeViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface ApplyTimeViewController ()

@end

@implementation ApplyTimeViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

         self.navigationItem.title = @"申请时间";
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
    [MobClick beginLogPageView:@"ApplyTimeViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ApplyTimeViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    
   self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 5;
    
     [self.noPassBtn addTarget:self action:@selector(setTwoNext) forControlEvents:UIControlEventTouchUpInside];
     [self.passBtn addTarget:self action:@selector(setMySubmit) forControlEvents:UIControlEventTouchUpInside];
     [self.orderDetailsButton addTarget:self action:@selector(setOrderDetailsNext) forControlEvents:UIControlEventTouchUpInside];
    
    self.orderDetailsButton.layer.masksToBounds = YES;
    self.orderDetailsButton.layer.cornerRadius = 5.f;
    self.orderDetailsButton.layer.borderWidth = 1.f;
    self.orderDetailsButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
    
    
     [self getSelectMasOrderInfoByOrderId];
    
    [self setNeedViewList:self.allDiction];
    
}
-(void)setOrderDetailsNext{
    OrderDetailsLookViewController * appraisalView = [[OrderDetailsLookViewController alloc] init];
                      appraisalView.order_id = self.order_id;
                     [self.navigationController pushViewController:appraisalView  animated:YES];
}
-(void)setTwoNext{
    OrderRejectViewController * appraisalView = [[OrderRejectViewController alloc] init];
                   appraisalView.order_id = self.order_id;
//                  [self.navigationController pushViewController:appraisalView  animated:YES];
    [self jumpViewControllerAndCloseSelf:appraisalView];
}

-(void)setNeedViewList:(NSMutableDictionary *)nsmutable{
    NSMutableArray * deviceList = [nsmutable objectForKey:@"deviceList"];
    int allHeight = 0;
    for (int i = 0;i< [deviceList count];i++) {
        NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
        NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"isRequerdList"];
        NSMutableArray * noRequerdList =  [oneItemDic objectForKey:@"noRequerdList"];
        int needHeight = 100 ;
        for(int j = 0; j < [isRequerdArray count]; j++){
            needHeight += 20;
        }
        
        int noRequestHeight = 100;
        for (int k = 0;k < [noRequerdList count];k++) {
            noRequestHeight += 20;
        }
        int curResultHeight = 0;
        if (needHeight > noRequestHeight) {
            curResultHeight =  needHeight;
        }else{
            curResultHeight =  noRequestHeight;
        }
        
        NeedView *    sinaNme = [[[NSBundle mainBundle] loadNibNamed:@"NeedView" owner:self options:nil] lastObject];
        sinaNme.frame = CGRectMake(0, allHeight, SCREEN_WIDTH, curResultHeight);
        [sinaNme.gpsAllView setHidden:YES];
        [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
        }];
        [self setNeedViewUpdate:sinaNme:isRequerdArray];
        [self setNoRequestViewUpdate:sinaNme:noRequerdList];
        [self.devicelist addSubview:sinaNme];
        
        allHeight += curResultHeight;
    }
      CGRect origionRect = self.linearoutwo.frame;
                   CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, allHeight);
                   self.linearoutwo.frame = newRect;
    
    CGRect  topRect = self.allView.frame;
                         CGRect topNewRect = CGRectMake(topRect.origin.x, topRect.origin.y, topRect.size.width, 210 + allHeight);
                         self.allView.frame = topNewRect;

    
}

-(void)setNeedViewUpdate:(NeedView *)sinaNme:(NSMutableArray *)isRequerdArray{
    sinaNme.deviceView.layer.cornerRadius = 8.0;
    sinaNme.deviceView.layer.masksToBounds = YES;
    sinaNme.deviceView.layer.borderWidth = 1;
    sinaNme.deviceView.layer.borderColor = [[UIColor colorWithRed:193/255.0 green:195/255.0 blue:225/255.0 alpha:1.0] CGColor];
    
    int myLengththree = 5;
    for(int i = 0; i < [isRequerdArray count]; i++){
        NSMutableDictionary * twoItemDic = [isRequerdArray objectAtIndex:i];
        NSString * content_name =  [twoItemDic objectForKey:@"content_name"];
        UILabel *needLabel = [[UILabel alloc]init];
        needLabel.frame = CGRectMake(10, myLengththree, 100, 20);
        needLabel.tag = i;
        needLabel.font=[UIFont systemFontOfSize:12];
        needLabel.textColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
        needLabel.text = content_name;
        [sinaNme.needView addSubview:needLabel];
        myLengththree += 20;
    }
    
}

-(void)setNoRequestViewUpdate:(NeedView *)sinaNme:(NSMutableArray *)noRequerdList{
    sinaNme.deviceView.layer.cornerRadius = 8.0;
    sinaNme.deviceView.layer.masksToBounds = YES;
    sinaNme.deviceView.layer.borderWidth = 1;
    sinaNme.deviceView.layer.borderColor = [[UIColor colorWithRed:193/255.0 green:195/255.0 blue:225/255.0 alpha:1.0] CGColor];
    
    int myLengththree = 5;
    for(int i = 0; i < [noRequerdList count]; i++){
        NSMutableDictionary * twoItemDic = [noRequerdList objectAtIndex:i];
               NSString * content_name =  [twoItemDic objectForKey:@"content_name"];
        UILabel *needLabel = [[UILabel alloc]init];
        needLabel.frame = CGRectMake(10, myLengththree, 100, 20);
        needLabel.textColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
        needLabel.tag = i;
        needLabel.font=[UIFont systemFontOfSize:12];
        needLabel.text = content_name;
        [sinaNme.noRequstView addSubview:needLabel];
        myLengththree += 20;
    }
    
}




// 工单详情
-(void)getSelectMasOrderInfoByOrderId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.order_id forKey:@"order_id"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMasOrderInfoByOrderId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectMasOrderInfoByOrderId:myResult];
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
-(void)setSelectMasOrderInfoByOrderId:(NSMutableDictionary *) nsmutable{
    
    NSString * order_code = [nsmutable objectForKey:@"order_code"];
      NSString * plan_start_time = [nsmutable objectForKey:@"plan_start_time"];
      NSString * plan_complete_time = [nsmutable objectForKey:@"plan_complete_time"];
    
   NSString * startTime =   [self getDeviceDateSix:plan_start_time];
      NSString * endTime =   [self getDeviceDateSix:plan_complete_time];
    
    self.startTimeLabel.text = startTime;
     self.endTimeLabel.text = endTime;
    
     NSString * startDate =  [self getDeviceDateSixThree:plan_start_time];
    NSString * endDate =  [self getDeviceDateSixThree:plan_complete_time];
    
    self.startDateLabel.text = startDate;
    self.endDateLabel.text = endDate;
    
    NSDateComponents * cmps = [self pleaseInsertStarTimeo:[self getDeviceDateSixFour:plan_start_time] andInsertEndTime:[self getDeviceDateSixFour:plan_complete_time]];
        
    //    cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second
        
        NSInteger yearInt = cmps.year;
    NSInteger monthInt =cmps.month;
    NSInteger dayInt = cmps.day;
    NSInteger hourInt = cmps.hour;
    NSInteger minuteInt = cmps.minute;
        
        NSString * dateString = @"";
        if (yearInt != 0) {
            NSString *string = [NSString stringWithFormat:@"%ld",(long)yearInt];
             dateString = [self getPinjieNSString:dateString:string];
            dateString = [self getPinjieNSString:dateString:@"年"];
        }
        if (monthInt != 0) {
            NSString *string = [NSString stringWithFormat:@"%ld",(long)monthInt];
               dateString = [self getPinjieNSString:dateString:string];
                   dateString = [self getPinjieNSString:dateString:@"月"];
          }
        if (dayInt != 0) {
            NSString *string = [NSString stringWithFormat:@"%ld",(long)dayInt];
                 dateString = [self getPinjieNSString:dateString:string];
                              dateString = [self getPinjieNSString:dateString:@"天"];
             }
        if (hourInt != 0) {
            NSString *string = [NSString stringWithFormat:@"%ld",(long)hourInt];
                 dateString = [self getPinjieNSString:dateString:string];
                              dateString = [self getPinjieNSString:dateString:@"时"];
             }
        if (minuteInt != 0) {
            NSString *string = [NSString stringWithFormat:@"%ld",(long)minuteInt];
                   dateString = [self getPinjieNSString:dateString:string];
                                dateString = [self getPinjieNSString:dateString:@"分"];
               }
        
        if ([self isBlankString:dateString]) {
            dateString = @"0小时";
        }
    self.centerTimeLabel.text =  [self getPinjieNSString:@"历时":dateString];
    
}

// 提交
-(void)setMySubmit{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"确定审批通过？" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        [self getZhuandBtn];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

-(void)getZhuandBtn{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
      
      NSMutableDictionary * dicnary = [self queryData];
      NSString *ptoken = [dicnary objectForKey:@"ptoken"];
      
      NSMutableDictionary * diction = [NSMutableDictionary dictionary];
      [diction setValue:ptoken forKey:@"token"];
      
      
      NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
      int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
      [diction setValue:@(app_Version) forKey:@"version_code"];
      [diction setValue:self.order_id forKey:@"order_id"];
      [diction setValue:@"1" forKey:@"sign"];
 
      
      NSString * url = [self getPinjieNSString:baseUrl :applyMaintenanceConfirm];
      
      [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
      [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
      
      [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
          id myResult =  [ self getMyResult:responseObject];
        
          int myCode = -1;
                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                     myCode  = [[responseObject objectForKey:@"code"] intValue];
                 }
                 if (myCode == 200) {
                     [self setZhuandBtn];
                     return;
                 }
                 NSString * myMessage =  [responseObject objectForKey:@"message"];
                 [self showToastTwo:myMessage];
          
      } failure:^(NSError *error) {
          //请求失败
          NSString * errorStr =  [self getError:error];
          [self showToastTwo:errorStr];
          
      }];

}
-(void)setZhuandBtn{

  MyEventBus * myEvent = [[MyEventBus alloc] init];
        myEvent.errorId = @"OrderDetailsViewController";
           [[QTEventBus shared] dispatch:myEvent];
    
                                 [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
                                        
                                         [self showToast:@"操作完成"];
}

@end

//
//  OrderDetailsLookViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/8/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "OrderDetailsLookViewController.h"
#import "SGPagingView.h"
#import "WRNavigationBar.h"
#import "Masonry.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"


@interface OrderDetailsLookViewController ()

@end

@implementation OrderDetailsLookViewController

-(NSMutableDictionary *)allDiction{
    if (!_allDiction) {
        _allDiction = [NSMutableDictionary dictionary];
    }
    return _allDiction;
}

-(NSMutableArray *)curButtons{
    if (!_curButtons) {
        _curButtons = [NSMutableArray array];
    }
    return _curButtons;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1.0];
    self.navigationItem.title = @"工单详情";
    
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
    [MobClick beginLogPageView:@"OrderDetailsViewController"];
     [self getSelectMasOrderInfoByOrderId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderDetailsViewController"];
}


-(void)initView{
    DZStarView *starView = [[DZStarView alloc] initWithMaxCount:5 value:4 canEvlaue:YES frame:CGRectMake(0, 0, 200, 50)];
    starView.delegate = self;
    [self.starOneView addSubview:starView];
    
    DZStarView *starViewtwo = [[DZStarView alloc] initWithMaxCount:5 value:4 canEvlaue:YES frame:CGRectMake(0, 0, 200, 50)];
    starViewtwo.delegate = self;
    [self.starTwoView addSubview:starViewtwo];
    
    DZStarView *starViewthree = [[DZStarView alloc] initWithMaxCount:5 value:4 canEvlaue:YES frame:CGRectMake(0, 0, 200, 50)];
    starViewthree.delegate = self;
    [self.starThreeView addSubview:starViewthree];
    
    [self allDiction];
    [self curButtons];
    
    self.workLog.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
    
    self.mainScrollView.showsVerticalScrollIndicator = FALSE; //垂直
    
    [self.workLog addGestureRecognizer:gesture];
    
    __weak typeof(self) weakSelf = self;
    [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
        __strong typeof(self) strongSelf = weakSelf;
      NSString * myErrorId =   event.errorId;
     if ([strongSelf getNSStringEqual:@"OrderDetailsViewController":myErrorId]) {
          [strongSelf getSelectMasOrderInfoByOrderId];
     }
    }];
    
}
-(void)tagGesture1{
    
    NSMutableArray * fixOrderFlowList =   [self.allDiction objectForKey:@"fixOrderFlowList"];
    
    MainWorkJournalViewController * alartDetail = [[MainWorkJournalViewController alloc] init];
    alartDetail.fixOrderFlowList = fixOrderFlowList;
    alartDetail.order_id = self.order_id;
    [self.navigationController pushViewController:alartDetail  animated:YES];
}

-(void)starView:(DZStarView *)starView didClick:(NSInteger)index{
    NSLog(@"等级 == %ld",index);
}


-(void)setScrollViewDic:(NSMutableDictionary *) nsmutable{
    
    int myLength = 0;
    
    NSMutableArray *  buttons =  [nsmutable objectForKey:@"buttons"];
    [self.curButtons removeAllObjects];
    for (NSString * buttonStr in buttons) {
        int buttonInt = [buttonStr intValue];
      if (buttonInt != 5 && buttonInt != 6 && buttonInt != 7) {
                [self.curButtons addObject:@(buttonInt)];
                             
                             int kuanInt = 0;
                             if ([self.curButtons count] == 1) {
                                 kuanInt = SCREEN_WIDTH;
                             }
                             if ([self.curButtons count] == 2) {
                                 kuanInt = SCREEN_WIDTH/2;
                             }
                             if ([self.curButtons count] == 3) {
                                 kuanInt = SCREEN_WIDTH/3;
                             }
                             if ([self.curButtons count] == 4) {
                                 kuanInt = SCREEN_WIDTH/4;
                             }
                             
                             
                             myLength += kuanInt;
            }
       
    }
}


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self setScrollViewDic:nsmutable];
    
    self.allDiction = nsmutable;
    self.statusStr = [nsmutable objectForKey:@"status"];
    
    int status =  [self.statusStr intValue];
    
    NSString * report_man_name = [nsmutable objectForKey:@"report_man_name"];
    NSString * update_time = [nsmutable objectForKey:@"update_time"];
    int operate_type = [[nsmutable objectForKey:@"operate_type"] intValue];
    NSString * report_man_depart = [nsmutable objectForKey:@"report_man_depart"];
    NSString * order_code = [nsmutable objectForKey:@"order_code"];
    NSString * type_name = [nsmutable objectForKey:@"order_name"];
    NSString * report_time = [nsmutable objectForKey:@"report_time"];
    NSString * target_device_name = [nsmutable objectForKey:@"target_device_name"];
    NSString * target_position_detail = [nsmutable objectForKey:@"target_position_detail"];
    NSString * content = [nsmutable objectForKey:@"content"];
    NSString * content_count = [nsmutable objectForKey:@"content_count"];
     NSString * plan_hour_num = [nsmutable objectForKey:@"plan_hour_num"];
    
    NSString * receive_man_name = [nsmutable objectForKey:@"receive_man_name"];
    NSString * receive_time = [nsmutable objectForKey:@"receive_time"];
    NSString * report_man_url = [nsmutable objectForKey:@"report_man_url"];
    NSString * receive_man_url = [nsmutable objectForKey:@"receive_man_url"];
    NSString * receive_man_depart = [nsmutable objectForKey:@"receive_man_depart"];
    NSString * complete_confirm_man_name = [nsmutable objectForKey:@"complete_confirm_man_name"];
    NSString * complete_confirm_man_depart = [nsmutable objectForKey:@"complete_confirm_man_depart"];
    NSString * complete_confirm_time = [nsmutable objectForKey:@"complete_confirm_time"];
    
    
    int is_success = [[nsmutable objectForKey:@"is_success"] intValue];
    
    
    NSMutableArray * statusList = [self getMainStatus:status];
    NSString * statusName = [statusList objectAtIndex:0];
    NSString * statusColor = [statusList objectAtIndex:1];
    
    NSMutableArray * logList = [self getAuthorityOprate:operate_type];
    NSString * logContent = [logList objectAtIndex:0];
    
    if ([self isBlankString:target_device_name]) {
        target_device_name = @"";
    }
    
    self.curState.text =  [self getPinjieNSString:@"当前状态：":statusName] ;
    self.curStateContent.text = [self getPinjieNSString:report_man_name:statusName];
    self.curStateTime.text = update_time;
    
    self.orderNumber.text = order_code;
    self.orderType.text = type_name;
    self.baoxTime.text = [self getPinjieNSString:[self getIntegerValue:content_count]:@"项"];
    self.baoxGoal.text = [self getPinjieNSString:[self getIntegerValue:plan_hour_num]:@"小时"];
    
    [self setNeedViewList:nsmutable];
    
}

-(UIView *)linearOneUiView{
    if (!_linearOneUiView) {
        _linearOneUiView = [[UIView alloc] init];
    }
    return _linearOneUiView;
}

-(void)setNeedViewList:(NSMutableDictionary *)nsmutable{
    NSMutableArray * deviceList = [nsmutable objectForKey:@"deviceList"];
    
     int allHeightTemp = 0;
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
         allHeightTemp += curResultHeight;
    }

    
//     self.linearOneUiView.backgroundColor = [UIColor redColor];
     self.linearOneUiView.frame = CGRectMake(0, 381, SCREEN_WIDTH, allHeightTemp);
     [self.allView addSubview:self.linearOneUiView];
  
    int allHeight = 0;
    
    for (int i = 0;i< [deviceList count];i++) {
        NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
        NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"isRequerdList"];
        NSMutableArray * noRequerdList =  [oneItemDic objectForKey:@"noRequerdList"];
        NSString * object_id = [oneItemDic objectForKey:@"object_id"];
        NSString * object_name = [oneItemDic objectForKey:@"object_name"];
      
        int needHeight = 150 ;
        int noRequestHeight = 150;
        int status =  [self.statusStr intValue];
        NSString * device_longitude = @"";
        NSString * device_latitude = @"";
        
//        if ([oneItemDic objectForKey:@"latitude"]) {
            device_latitude =  [oneItemDic objectForKey:@"latitude"] ;
//        }
//        if ([oneItemDic objectForKey:@"longitude"]) {
            device_longitude =  [oneItemDic objectForKey:@"longitude"] ;
//        }
        
        if ([self isBlankString:device_longitude]) {
            device_longitude = @"";
        }
        if ([self isBlankString:device_latitude]) {
            device_latitude = @"";
        }
        
        
        if ([self isBlankString:device_longitude] || [self isBlankString:device_latitude]) {
            needHeight = 100;
            noRequestHeight = 100;
        }else{
            if (status >= 4) {
                needHeight = 150;
                noRequestHeight = 150;
            }else{
                needHeight = 100;
                noRequestHeight = 100;
            }
            if (status == 5 && ![self.curButtons containsObject:@(1)] && ![self.curButtons containsObject:@(2)] && ![self.curButtons containsObject:@(3)]) {
                needHeight = 150;
                noRequestHeight = 150;
            }else{
                needHeight = 100;
                noRequestHeight = 100;
            }
        }
        
        for(int j = 0; j < [isRequerdArray count]; j++){
            needHeight += 20;
        }
        
        for (int k = 0;k < [noRequerdList count];k++) {
            noRequestHeight += 20;
        }
        int curResultHeight = 0;
        if (needHeight > noRequestHeight) {
            curResultHeight =  needHeight;
        }else{
            curResultHeight =  noRequestHeight;
        }
                
        UINib *nib = [UINib nibWithNibName:@"NeedView" bundle:nil];
        NeedView *sinaNme = [[nib instantiateWithOwner:nil options:nil] lastObject];
       
        sinaNme.tag = i;
        sinaNme.frame = CGRectMake(0, allHeight, SCREEN_WIDTH, curResultHeight);
        
        sinaNme.webName.text = object_name;
        
        NSString *ddPointTag = [NSString stringWithFormat:@"%d", i];
        sinaNme.ddPointButton.userId = ddPointTag;
        sinaNme.ddPointButton.createUserId = device_latitude;
        sinaNme.ddPointButton.workStatus = device_longitude;
        [sinaNme.ddPointButton addTarget:self action:@selector(setToProcessOrder:) forControlEvents:UIControlEventTouchUpInside];
       
        
        sinaNme.ddPointButton.layer.cornerRadius = 5; 
        sinaNme.ddPointButton.layer.masksToBounds = YES;
        
        [self setNeedViewUpdate:sinaNme:isRequerdArray];
               [self setNoRequestViewUpdate:sinaNme:noRequerdList];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2:)];
                  [sinaNme addGestureRecognizer:gesture];
    
        allHeight += curResultHeight;
        
        [self.linearOneUiView addSubview:sinaNme];
        
        if ([self isBlankString:device_longitude] || [self isBlankString:device_latitude]) {
        
            [sinaNme.gpsAllView setHidden:YES];
            [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(10);
            }];
        }else{
            if (status >= 4) {
              
                [sinaNme.gpsAllView setHidden:NO];
                [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(60);
                }];
            }else{
               
                [sinaNme.gpsAllView setHidden:YES];
                [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10);
                }];
            }
            if (status == 5 && ![self.curButtons containsObject:@(1)] && ![self.curButtons containsObject:@(2)] && ![self.curButtons containsObject:@(3)]) {
                [sinaNme.gpsAllView setHidden:NO];
                [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(60);
                }];
            }else{
                [sinaNme.gpsAllView setHidden:YES];
                [sinaNme.gpsAllView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10);
                }];
            }
        }
    
    }
    
     self.linearouthree.transform=CGAffineTransformMakeTranslation(0, allHeight);
    
    
//          CGRect origionRect = self.linearoutwo.frame;
//             CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, allHeight);
//             self.linearoutwo.frame = newRect;
          
    [self setWbCondition:allHeight:nsmutable];
         
}



-(void)tagGesture2:(UITapGestureRecognizer *)myTopTwo{
 NeedView *iView =(NeedView *) myTopTwo.view;
  NSInteger tagInt =   iView.tag;
    NSString *stringInt = [NSString stringWithFormat:@"%d", tagInt];
    
    ProcessOrderViewController * alartDetail = [[ProcessOrderViewController alloc] init];
                  alartDetail.order_id = self.order_id;
    alartDetail.curPosition = stringInt;
    alartDetail.statusStr = self.statusStr;
    alartDetail.isLook = @"false";
                  [self.navigationController pushViewController:alartDetail  animated:YES];

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
        needLabel.tag = i;
        needLabel.font=[UIFont systemFontOfSize:12];
        needLabel.textColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
        needLabel.text = content_name;
        [sinaNme.noRequstView addSubview:needLabel];
        myLengththree += 20;
        
    }

}


-(void)setWbCondition:(int)aboutHeight :(NSMutableDictionary *)nsmutable{
    NSMutableArray * orderSpareList = [nsmutable objectForKey:@"orderSpareList"];
    int wdCondtionHeight = 5;
    for(int i = 0; i < [orderSpareList count]; i++){
        wdCondtionHeight += 20;
    }
    UIView *sinaNme = [[UIView alloc]init];
    sinaNme.backgroundColor = [UIColor whiteColor];
    sinaNme.frame = CGRectMake(0, 51, SCREEN_WIDTH, wdCondtionHeight);
    [self.linearouthree addSubview:sinaNme];
    
    int myLengththree = 5;
    for(int i = 0; i < [orderSpareList count]; i++){
        NSMutableDictionary * threeItemDic = [orderSpareList objectAtIndex:i];
        NSString * spare_name  =  [threeItemDic objectForKey:@"spare_name"];
        NSString * spare_model  =  [threeItemDic objectForKey:@"spare_model"];
        NSString * spare_count  =  [self getIntegerValue:[threeItemDic objectForKey:@"spare_count"]];
        NSString * unit  =  [threeItemDic objectForKey:@"unit"];
        
        NSString * webBj = @"";
        webBj =  [self getPinjieNSString:spare_name:spare_model];
        webBj =  [self getPinjieNSString:webBj:@""];
        webBj =  [self getPinjieNSString:webBj:spare_count];
        webBj =  [self getPinjieNSString:webBj:unit];
        
        UILabel *needLabel = [[UILabel alloc]init];
        needLabel.frame = CGRectMake(30, myLengththree, SCREEN_WIDTH - 40, 20);
        needLabel.tag = i;
        needLabel.font=[UIFont systemFontOfSize:12];
        needLabel.text = webBj;
        //            needLabel.backgroundColor = [UIColor whiteColor];
        
        
        [sinaNme addSubview:needLabel];
        myLengththree += 20;
    }
    //      self.conditionView.backgroundColor = [UIColor redColor];
    int deviceHeight = aboutHeight + myLengththree;
    
      int myHeight =  deviceHeight - 51 + 10;
    
    self.linearoutfour.transform=CGAffineTransformMakeTranslation(0, myHeight );
    
    CGRect  topRect = sinaNme.frame;
                      CGRect topNewRect = CGRectMake(topRect.origin.x, topRect.origin.y, topRect.size.width, myLengththree  + 10);
                      sinaNme.frame = topNewRect;
    
    CGRect origionRect = self.linearouthree.frame;
                CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, myLengththree + 51 + 10);
                self.linearouthree.frame = newRect;
    
    [self setWbTool:myHeight:nsmutable];
    
}

-(void)setWbTool:(int)toolHeight:(NSMutableDictionary *)nsmutable{
     NSMutableArray * orderToolList = [nsmutable objectForKey:@"orderToolList"];
    int wdCondtionHeight = 5;
    for(int i = 0; i < [orderToolList count]; i++){
        wdCondtionHeight += 20;
    }
    UIView *sinaNme = [[UIView alloc]init];
    sinaNme.backgroundColor = [UIColor whiteColor];
    sinaNme.frame = CGRectMake(0, 51, SCREEN_WIDTH, wdCondtionHeight);
    [self.linearoutfour addSubview:sinaNme];
    
    int myLengththree = 5;
    for(int i = 0; i < [orderToolList count]; i++){
        NSMutableDictionary * threeItemDic = [orderToolList objectAtIndex:i];
        NSString * spare_name  =  [threeItemDic objectForKey:@"spare_name"];
        NSString * spare_model  =  [threeItemDic objectForKey:@"spare_model"];
        NSString * spare_count  =  [self getIntegerValue:[threeItemDic objectForKey:@"spare_count"]];
        NSString * unit  =  [threeItemDic objectForKey:@"unit"];
        
        NSString * webBj = @"";
        webBj =  [self getPinjieNSString:spare_name:spare_model];
        webBj =  [self getPinjieNSString:webBj:@""];
        webBj =  [self getPinjieNSString:webBj:spare_count];
        webBj =  [self getPinjieNSString:webBj:unit];
        
        UILabel *needLabel = [[UILabel alloc]init];
        needLabel.frame = CGRectMake(30, myLengththree, SCREEN_WIDTH - 40, 20);
        needLabel.tag = i;
        needLabel.font=[UIFont systemFontOfSize:12];
        needLabel.text = webBj;
        //            needLabel.backgroundColor = [UIColor whiteColor];
        [sinaNme addSubview:needLabel];
        myLengththree += 20;
    }
    
    int deviceHeight = toolHeight + myLengththree;
    
     int myHeight =  deviceHeight - 51;
    self.linearoutfive.transform=CGAffineTransformMakeTranslation(0, myHeight);
    
    CGRect  topRect = sinaNme.frame;
                    CGRect topNewRect = CGRectMake(topRect.origin.x, topRect.origin.y, topRect.size.width, myLengththree  + 10);
                    sinaNme.frame = topNewRect;
    
    CGRect origionRect = self.linearoutfour.frame;
                  CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, myLengththree + 51 + 10);
                  self.linearoutfour.frame = newRect;
    
  
    int allHeight = 550 + myHeight + NAV_HEIGHT + 50 ;
    
    [self.allView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(allHeight);
           }];
    
    
}


@end

//
//  MaintenanceListDetailsViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MaintenanceListDetailsViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface MaintenanceListDetailsViewController ()

@end

@implementation MaintenanceListDetailsViewController


-(NSMutableDictionary *)dictionNsmu{
    if (!_dictionNsmu) {
        _dictionNsmu = [NSMutableDictionary dictionary];
    }
    return _dictionNsmu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
      self.navigationItem.title = @"维保详情";
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
    [MobClick beginLogPageView:@"MaintenanceListDetailsViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MaintenanceListDetailsViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setAboutView{
    int curPositionInt = [self.curPosition intValue];
    curPositionInt--;
    self.curPosition = [NSString stringWithFormat:@"%d", curPositionInt];
    [self setCurTreeItem];
}
-(void)setNextView{
    int curPositionInt = [self.curPosition intValue];
    curPositionInt++;
    self.curPosition = [NSString stringWithFormat:@"%d", curPositionInt];
    [self setCurTreeItem];
}

-(void)setCurTreeItem{
    int curPositionInt = [self.curPosition intValue];
    if (curPositionInt < 0) {
        curPositionInt = 0;
        self.curPosition = [NSString stringWithFormat:@"%d", curPositionInt];
        return;
    }
    NSMutableArray * deviceList =  [self.dictionNsmu objectForKey:@"deviceList"];
    if (curPositionInt >= [deviceList count]){
        curPositionInt = [deviceList count] - 1;
        return;
    }
    
    [self setPrcessOrder];
}

- (void)initView{
    
    [self.addWebBtn addTarget:self action:@selector(setToAddWei) forControlEvents:UIControlEventTouchUpInside];
    [self.abovtButton addTarget:self action:@selector(setAboutView) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(setNextView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self dictionNsmu];
    
    [self getSelectMasOrderInfoByOrderId];
    
    [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
        NSString * myErrorId =   event.errorId;
        if ([self getNSStringEqual:@"ProcessOrderViewController":myErrorId]) {
            [self getSelectMasOrderInfoByOrderId];
        }
    }];
}
-(void)setToAddWei{
    
     int status =  [self.statusStr intValue];
    if (status != 5) {
        return;
    }
    
    AddMainProjectViewController * applyBackUp = [[AddMainProjectViewController alloc] init];
    applyBackUp.order_id = self.order_id;
    applyBackUp.dictionNsmu = self.dictionNsmu;
    applyBackUp.curPosition = self.curPosition;
    [self.navigationController pushViewController:applyBackUp  animated:YES];
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
-(void)setPrcessOrder{
    for (UIView * view in self.linearOneUiView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView * view in self.linearTwoUiView.subviews) {
        [view removeFromSuperview];
    }
    
    
    NSMutableArray * deviceList =  [self.dictionNsmu objectForKey:@"deviceList"];
    int allHeightTemp = 0;
    int allHeightTempNo = 0;
    for (int i = 0;i< [deviceList count];i++) {
        int tempInt = [self.curPosition intValue];
        if (tempInt == i) {
            NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
            
            NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"isRequerdList"];
            for(int j = 0; j < [isRequerdArray count]; j++){
                allHeightTemp += 30;
            }
            NSMutableArray * isRequerdArrayNo =  [oneItemDic objectForKey:@"noRequerdList"];
            for(int j = 0; j < [isRequerdArrayNo count]; j++){
                allHeightTempNo += 30;
            }
        }
        
    }
    
    int moReaa = 51 + allHeightTemp + 51 + 10;
    
    self.linearOneUiView.frame = CGRectMake(0, 51, SCREEN_WIDTH, allHeightTemp);
    self.linearOneUiView.backgroundColor = [UIColor whiteColor];
    [self.allView addSubview:self.linearOneUiView];
    
    self.linearTwoUiView.frame = CGRectMake(0, moReaa, SCREEN_WIDTH, allHeightTempNo);
    self.linearTwoUiView.backgroundColor = [UIColor whiteColor];
    [self.allView addSubview:self.linearTwoUiView];
    
    int myLengththree = 0;
    int myLengthtfour = 0;
    for (int i = 0;i< [deviceList count];i++) {
        int tempInt = [self.curPosition intValue];
        if (tempInt == i) {
            NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
            
            NSString * object_name =  [oneItemDic objectForKey:@"object_name"];
            self.gdName.text = object_name;
            
            NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"isRequerdList"];
            NSMutableArray * complateInt = [NSMutableArray array];
            for(int j = 0; j < [isRequerdArray count]; j++){
                NSMutableDictionary * twoItemDic = [isRequerdArray objectAtIndex:j];
                
                NSString * content_name =  [twoItemDic objectForKey:@"content_name"];
                NSString * content_in_id =  [twoItemDic objectForKey:@"content_in_id"];
                NSString * content_id =  [twoItemDic objectForKey:@"content_id"];
                NSString * content =  [twoItemDic objectForKey:@"content"];
                NSString * is_image =  [twoItemDic objectForKey:@"is_image"];
                NSString * status = [twoItemDic objectForKey:@"status"];
                int statusitem = [status intValue];
                if (statusitem != 2) {
                    [complateInt addObject:twoItemDic];
                }else{
               
                    UIImageView *sinaNme = [[UIImageView alloc]init];
                           sinaNme.frame = CGRectMake(SCREEN_WIDTH - 30, 0,30, 30);
                    UIImage * imgbItem = [UIImage imageNamed:@"complete.png"];
                     sinaNme.image = imgbItem;
                      [self.linearOneUiView addSubview:sinaNme];
                }
             
                ProLabel *needLabel = [[ProLabel alloc]init];
                needLabel.frame = CGRectMake(30, myLengththree, SCREEN_WIDTH - 40, 30);
                needLabel.tag = j;
                needLabel.font=[UIFont systemFontOfSize:12];
                
                int mk = j + 1;
                NSString *jStr = [NSString stringWithFormat:@"%d", mk];
                jStr= [self getPinjieNSString:jStr:@"."];
                jStr = [self getPinjieNSString:jStr:content_name];
                needLabel.text = jStr;
                
                CALayer *lineLayer = [CALayer layer];
                lineLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0].CGColor;
                lineLayer.frame = CGRectMake(0, needLabel.frame.size.height, needLabel.frame.size.width,1);
                [needLabel.layer addSublayer:lineLayer];
                
                needLabel.deviceId = is_image;
                needLabel.dataId = content_name;
                needLabel.data_type = content_in_id;
                needLabel.positionStr = content_id;
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:jStr];
                [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] range:NSMakeRange(0, text.length)];
                needLabel.attributedText = text;
                
                [needLabel setUserInteractionEnabled:YES];
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2:)];
                [needLabel addGestureRecognizer:gesture];
                
                [self.linearOneUiView addSubview:needLabel];
                myLengththree += 30;
            }
            NSString * allNstr = @"";
            NSString * allNstrOne = @"";
            NSString *isRequstStr = [NSString stringWithFormat:@"%d", [isRequerdArray count]];
            NSString *comPlateStr = [NSString stringWithFormat:@"%d", [complateInt count]];
            allNstr = [self getPinjieNSString:allNstr:@"共"];
            allNstr = [self getPinjieNSString:allNstr:isRequstStr];
            allNstr = [self getPinjieNSString:allNstr:@"项"];
            
            [self.wbOneView setTitle:allNstr forState:UIControlStateNormal];
            
            allNstrOne = [self getPinjieNSString:allNstrOne:@"已完成"];
            allNstrOne = [self getPinjieNSString:allNstrOne:isRequstStr];
            allNstrOne = [self getPinjieNSString:allNstrOne:@"项"];
            [self.wbListAll setTitle:allNstrOne forState:UIControlStateNormal];
            
            //  可选维保项
            NSMutableArray * complateIntNo = [NSMutableArray array];
            NSMutableArray * noRequerdArray =  [oneItemDic objectForKey:@"noRequerdList"];
            for(int j = 0; j < [noRequerdArray count]; j++){
                NSMutableDictionary * twoItemDic = [noRequerdArray objectAtIndex:j];
                
                NSString * content_name =  [twoItemDic objectForKey:@"content_name"];
                NSString * content_in_id =  [twoItemDic objectForKey:@"content_in_id"];
                NSString * content_id =  [twoItemDic objectForKey:@"content_id"];
                NSString * content =  [twoItemDic objectForKey:@"content"];
                NSString * is_image =  [twoItemDic objectForKey:@"is_image"];
                NSString * status = [twoItemDic objectForKey:@"status"];
                int statusitem = [status intValue];
                if (statusitem != 2) {
                    [complateIntNo addObject:twoItemDic];
                }
                
                ProLabel *needLabel = [[ProLabel alloc]init];
                needLabel.frame = CGRectMake(30, myLengthtfour, SCREEN_WIDTH - 40, 30);
                needLabel.tag = j;
                needLabel.font=[UIFont systemFontOfSize:12];
                
                int mk = j + 1;
                NSString *jStr = [NSString stringWithFormat:@"%d", mk];
                jStr= [self getPinjieNSString:jStr:@"."];
                jStr = [self getPinjieNSString:jStr:content_name];
                needLabel.text = jStr;
                
                CALayer *lineLayer = [CALayer layer];
                lineLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0].CGColor;
                lineLayer.frame = CGRectMake(0, needLabel.frame.size.height, needLabel.frame.size.width,1);
                [needLabel.layer addSublayer:lineLayer];
                
                needLabel.deviceId = is_image;
                needLabel.dataId = content_name;
                needLabel.data_type = content_in_id;
                needLabel.positionStr = content_id;
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:jStr];
                [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] range:NSMakeRange(0, text.length)];
                needLabel.attributedText = text;
                
                [needLabel setUserInteractionEnabled:YES];
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2:)];
                [needLabel addGestureRecognizer:gesture];
                
                [self.linearTwoUiView addSubview:needLabel];
                myLengthtfour += 30;
            }
        }
        
    }
    
    int allHeight = myLengththree;
    
    self.optonal.transform=CGAffineTransformMakeTranslation(0, allHeight );
    
}
-(void)setSelectMasOrderInfoByOrderId:(NSMutableDictionary *) nsmutable{
    NSMutableArray * deviceList =  [nsmutable objectForKey:@"deviceList"];
    self.dictionNsmu = nsmutable;
    [self setPrcessOrder];
}

-(void)tagGesture2:(UITapGestureRecognizer *)myTopTwo{
    
    ProLabel *iView =(ProLabel *) myTopTwo.view;
    NSString * is_image  = iView.deviceId;
    NSString * content  = iView.dataId;
    NSString * content_in_id  = iView.data_type;
    NSString * content_id  = iView.positionStr;
    
    int status =  [self.statusStr intValue];
  if (status == 5) {
      MainContentViewController * alartDetail = [[MainContentViewController alloc] init];
         alartDetail.order_id = self.order_id;
         alartDetail.content_in_id = content_in_id;
         alartDetail.orderJson = self.dictionNsmu;
         alartDetail.content_id = content_id;
         alartDetail.content = content;
         alartDetail.is_image = is_image;
         [self.navigationController pushViewController:alartDetail  animated:YES];
      return;
  }
  
  MainContentLookViewController * alartDetail = [[MainContentLookViewController alloc] init];
     alartDetail.order_id = self.order_id;
     alartDetail.content_in_id = content_in_id;
     alartDetail.orderJson = self.dictionNsmu;
     alartDetail.content_id = content_id;
     alartDetail.content = content;
     alartDetail.is_image = is_image;
     [self.navigationController pushViewController:alartDetail  animated:YES];
    
//    MainContentLookViewController * alartDetail = [[MainContentLookViewController alloc] init];
//                alartDetail.order_id = self.order_id;
//                alartDetail.content_in_id = content_in_id;
//                alartDetail.orderJson = self.dictionNsmu;
//                alartDetail.content_id = content_id;
//                alartDetail.content = content;
//                alartDetail.is_image = is_image;
//                [self.navigationController pushViewController:alartDetail  animated:YES];
}

-(UIView *)linearOneUiView{
    if (!_linearOneUiView) {
        _linearOneUiView = [[UIView alloc] init];
        
    }
    return _linearOneUiView;
}

-(UIView *)linearTwoUiView{
    if (!_linearTwoUiView) {
        _linearTwoUiView = [[UIView alloc] init];
        
    }
    return _linearTwoUiView;
}

@end

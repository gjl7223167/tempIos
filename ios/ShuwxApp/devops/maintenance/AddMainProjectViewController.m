//
//  AddMainProjectViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "AddMainProjectViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface AddMainProjectViewController ()

@end

@implementation AddMainProjectViewController

-(NSMutableDictionary *)dictionNsmu{
    if (!_dictionNsmu) {
        _dictionNsmu = [NSMutableDictionary dictionary];
    }
    return _dictionNsmu;
}
-(UIView *)linearOneUiView{
    if (!_linearOneUiView) {
        _linearOneUiView = [[UIView alloc] init];
        
    }
    return _linearOneUiView;
}

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.navigationItem.title = @"工单处理";
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
    [MobClick beginLogPageView:@"AddMainProjectViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddMainProjectViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    [self dictionNsmu];
    
      [self.addMainButton addTarget:self action:@selector(getUpdataContextIsCheck) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray * deviceList =  [self.dictionNsmu objectForKey:@"deviceList"];
    
    int allHeightTemp = 0;
    for (int i = 0;i< [deviceList count];i++) {
        int tempInt = [_curPosition intValue];
        if (tempInt == i) {
            NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
            NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"noRequerdList"];
            for(int j = 0; j < [isRequerdArray count]; j++){
                allHeightTemp += 30;
            }
        }
        
    }
    
    self.linearOneUiView.frame = CGRectMake(0, 51, SCREEN_WIDTH, allHeightTemp);
    self.linearOneUiView.backgroundColor = [UIColor whiteColor];
    [self.allView addSubview:_linearOneUiView];
    
    int myLengththree = 0;
    for (int i = 0;i< [deviceList count];i++) {
        int tempInt = [_curPosition intValue];
        if (tempInt == i) {
            NSMutableDictionary * oneItemDic =  [deviceList objectAtIndex:i];
            NSMutableArray * isRequerdArray =  [oneItemDic objectForKey:@"noRequerdList"];
            for(int j = 0; j < [isRequerdArray count]; j++){
                NSMutableDictionary * twoItemDic = [isRequerdArray objectAtIndex:j];
                NSString * content_name =  [twoItemDic objectForKey:@"content_name"];
                 NSString * content_in_id =  [twoItemDic objectForKey:@"content_in_id"];
                int content_in_id_int = [content_in_id intValue];
                
                UIButton *needLabel = [UIButton buttonWithType:UIButtonTypeCustom];
                [needLabel addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
                needLabel.frame = CGRectMake(30, myLengththree, 250, 30);
                needLabel.tag = content_in_id_int;
                [needLabel setTitle:content_name forState:UIControlStateNormal];
                needLabel.titleLabel.font = [UIFont systemFontOfSize:14];
                needLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                UIImage* icon1 = [UIImage imageNamed:@"wbselectno"];
                [needLabel setImage:icon1 forState:UIControlStateNormal];
                
                //                UIImage* icon2 = [UIImage imageNamed:@"wbselect"];
                //                [needLabel setImage:icon2 forState:UIControlStateHighlighted];
                
                [needLabel setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                [needLabel setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
                
                //                                              UILabel *needLabel = [[UILabel alloc]init];
                //                                              needLabel.frame = CGRectMake(30, myLengththree, 100, 30);
                //                                              needLabel.tag = i;
                //                                              needLabel.font=[UIFont systemFontOfSize:12];
                //                                              needLabel.text = content_name;
                [self.linearOneUiView addSubview:needLabel];
                
                
                UIButton *weibTj = [UIButton buttonWithType:UIButtonTypeCustom];
                [weibTj addTarget:self action:@selector(setToDimiss:) forControlEvents:UIControlEventTouchUpInside];
                weibTj.frame = CGRectMake(SCREEN_WIDTH - 80, myLengththree + 5,60, 20);
                weibTj.tag = content_in_id_int;
                [weibTj setTitle:@"维保条件" forState:UIControlStateNormal];
                weibTj.titleLabel.font = [UIFont systemFontOfSize:12];
                [weibTj setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                
                [weibTj.layer setMasksToBounds:YES];
                       [weibTj.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
                 [weibTj.layer setBorderWidth:1.0];
                weibTj.layer.borderColor=[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
                
                [self.linearOneUiView addSubview:weibTj];
                
                myLengththree += 30;
                
            }
        }
    }
}
-(void)setToDimiss:(UIButton *)myButton{
     NSInteger tempButton = myButton.tag;
   NSString *content_in_id = [NSString stringWithFormat:@"%d",tempButton];
    
    WbConditionViewController * controller = [[WbConditionViewController alloc] init];
    controller.content_in_id = content_in_id;
    
          controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
          controller.providesPresentationContextTransitionStyle = YES;
          controller.definesPresentationContext = YES;
          controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
          //UIModalPresentationOverCurrentContext IOS 8.0 以后才出的方法 所以处理略有不同(很奇怪的是8.0以后的系统 如果这里采用以前的方法 屏幕背景就会在视图加载完成过后的一瞬间变黑)
          [self presentViewController:controller animated:YES completion:nil];
}
-(void)btnPress:(UIButton *)myButton{
    NSInteger tempButton = myButton.tag;
    BOOL isbool = [self.selectArray containsObject: @(tempButton)];
    if (isbool) {
        UIImage* icon2 = [UIImage imageNamed:@"wbselectno"];
        [myButton setImage:icon2 forState:UIControlStateNormal];
        [self.selectArray removeObject:@(tempButton)];
    }else{
        UIImage* icon2 = [UIImage imageNamed:@"wbselect"];
        [myButton setImage:icon2 forState:UIControlStateNormal];
        [self.selectArray addObject:@(tempButton)];
    }
    
}




//  更新可选中状态
-(void)getUpdataContextIsCheck{
    
   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSString * helpMan = @"";
    for(int i = 0;i < [self.selectArray count];i++) {
       int content_in_id = [[self.selectArray objectAtIndex:i] intValue];
        NSString *user_id = [NSString stringWithFormat:@"%d", content_in_id];
      helpMan =  [self getPinjieNSString:helpMan:user_id];
         helpMan =  [self getPinjieNSString:helpMan:@","];
    }
    
    if([self isBlankString:helpMan]){
        return;
    }
    
    int helpLength = [helpMan length] - 1;
    NSString * subString1 = [helpMan substringToIndex:helpLength];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@(1) forKey:@"is_check"];
     [diction setValue:subString1 forKey:@"content_in_ids"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :updataContextIsCheck];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
//    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
          int myCode = -1;
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         myCode  = [[responseObject objectForKey:@"code"] intValue];
                                     }
                                     if (myCode == 200) {
                                         [self setUpdataContextIsCheck];
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
-(void)setUpdataContextIsCheck{
   
    MyEventBus * myEvent = [[MyEventBus alloc] init];
              myEvent.errorId = @"ProcessOrderViewController";
                 [[QTEventBus shared] dispatch:myEvent];
          
                                       [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
                                              
                                               [self showToast:@"操作成功！"];
}

@end

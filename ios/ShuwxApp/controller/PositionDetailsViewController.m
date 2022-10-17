//
//  PositionDetailsViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "PositionDetailsViewController.h"
#import "WRNavigationBar.h"



@interface PositionDetailsViewController ()

@end

@implementation PositionDetailsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PositionDetailsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PositionDetailsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
      self.navigationItem.title = @"位置信息";
     
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


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView{
    
      [self.bottomPic addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self getSelectPositionByUUID];

}



// 查询位置
-(void)getSelectPositionByUUID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.deviceuuid forKey:@"position_uuid"];
  
    
    NSString * url = [self getPinjieNSString:baseUrl :selectPositionByUUID];
  
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
            [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectPositionByUUID:myResult];
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
-(void)setSelectPositionByUUID:(NSMutableDictionary *) nsmutable{
   NSString * pos_id = [nsmutable objectForKey:@"pos_id"];
     NSString * pos_name = [nsmutable objectForKey:@"pos_name"];
    
   self.posName.text = pos_name;
}

//点击事件
-(void)singleTapAction{
    ShowRepairViewController * allWorkOrder = [[ShowRepairViewController alloc] init];
    allWorkOrder.deviceuuid = self.deviceuuid;
                       allWorkOrder.devicetype = self.devicetype;
            [self.navigationController pushViewController:allWorkOrder animated:YES];
}

@end

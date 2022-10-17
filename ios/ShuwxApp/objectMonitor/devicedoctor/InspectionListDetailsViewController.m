//
//  InspectionListDetailsViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "InspectionListDetailsViewController.h"
#import "WRNavigationBar.h"
#import "InspectionLookView.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface InspectionListDetailsViewController ()
@property (strong, nonatomic)  InspectionLookView *threeView;
@end

@implementation InspectionListDetailsViewController

-(InspectionLookView *)threeView{
    if (!_threeView) {
//        _threeView = [[[NSBundle mainBundle] loadNibNamed:@"LookPointView" owner:self options:nil] lastObject];
        _threeView  = [[InspectionLookView alloc] init];
        _threeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_threeView.aboveBtn setHidden:YES];
         [_threeView.nextBtn setHidden:YES];
        _threeView.myViewController = self;
        [self.view addSubview:_threeView];
      
        
//        [_threeView setLookPoint];
        
        [self.view addSubview:_threeView];
        
    }
    return _threeView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"InspectionListDetailsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"InspectionListDetailsViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
            self.navigationItem.title = @"巡检详情";
           
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
    [self threeView];
//    [_threeView setHidden:YES];
    [self getSelectMyJobPointItemByPointIdDetails];
}



// 查询点位详情 状态是  2
-(void)getSelectMyJobPointItemByPointIdDetails{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
//    NSString * jobId = [self getIntegerValue:_job_id];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.point_id forKey:@"point_id"];
    [diction setValue:self.job_id forKey:@"job_id"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMyJobPointItemByPointIdDetails];
     
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectMyJobPointItemByPointIdDetails:myResult];
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
-(void)setSelectMyJobPointItemByPointIdDetails:(NSMutableArray *) nsmutable{
    
    int target_type_int = [self.target_type intValue];
    NSString * pointJcmbValue = @"";
    
    if (target_type_int == 1) {
        pointJcmbValue = self.target_position_detail;
    }else{
        pointJcmbValue = self.target_device_name;
    }
    
    NSString * sorString = [self getIntegerValue:self.is_sort];
    
    NSMutableDictionary * poiDic = [NSMutableDictionary dictionary];
           [poiDic setValue:self.is_sort forKey:@"pointXh"];
           [poiDic setValue:self.point_name forKey:@"pointNm"];
           [poiDic setValue:self.point_target forKey:@"pointJcmb"];
           [poiDic setValue:@"位置信息" forKey:@"pointWzxx"];
    [poiDic setValue:self.target_type forKey:@"target_type"];
    [poiDic setValue:self.target_position_detail forKey:@"target_position_detail"];
    [poiDic setValue:self.target_device_name forKey:@"target_device_name"];
    [poiDic setValue:self.point_name forKey:@"point_name"];
    [poiDic setValue:self.pos_name forKey:@"pos_name"];
    [poiDic setValue:self.target_device_code forKey:@"target_device_code"];
    [poiDic setValue:self.check_type forKey:@"check_type"];
    [poiDic setValue:sorString forKey:@"is_sort"];
           
           self.threeView.pointDic = poiDic;
    
    [self.threeView setList:nsmutable];
    NSLog(@"dgg");
    
 
    
}


@end

//
//  PersonalInfomationViewController.m
//  ShuwxApp
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "PersonalInfomationViewController.h"
#import "WRNavigationBar.h"



@interface PersonalInfomationViewController ()

@end

@implementation PersonalInfomationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PersonalInfomationViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PersonalInfomationViewController"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.   willDealloc
   
    self.navigationItem.title = @"个人信息";
    
    
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
     [self getUserList];
}
-(void)setScan{
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    self.touxImage.layer.cornerRadius = self.touxImage.frame.size.height/2;
    self.touxImage.layer.masksToBounds = YES;

}

-(void)getUserList{
   
    NSMutableDictionary * setInfo = [self queryData];
    
    NSString *ptoken = [setInfo objectForKey:@"ptoken"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];

     [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectUserInfoById];
   
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setInfomation:myResult];
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
-(void)setInfomation:(NSMutableDictionary *)dicnAry{
    
    NSString * user_name = [dicnAry objectForKey:@"userName"];
    NSString * user_nike_name = [dicnAry objectForKey:@"userNickName"];
    NSString * user_email = [dicnAry objectForKey:@"userEmail"];
    NSString * user_phone = [dicnAry objectForKey:@"userPhone"];
    NSString * head_img = [dicnAry objectForKey:@"headImg"];
//    NSString * depart_name = [dicnAry objectForKey:@"departName"];
    long user_sex = [[dicnAry objectForKey:@"userSex"] longValue];
   
    self.loginName.text = user_name;
    self.userName.text =  user_nike_name;
    if (user_sex == 1) {
        self.sexName.text = @"男";
    }else{
        self.sexName.text = @"女";
    }
    self.yidongPhone.text =  user_phone;
    self.emailName.text = user_email;
    
    self.loginName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.userName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.sexName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.yidongPhone.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.emailName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
    NSString * imageUrl =  [self getPinjieNSString:pictureUrl:head_img];
    
//    NSString *path = [[NSBuddle mainBuddle] pathForResource:@"resourceName" oftype@"resourceType"];
//    UIImage *image = [[UIImage imageWithContentsOfFile:path];
    
    NSString  * defaultImage = @"tempimage";
    [self.touxImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
    
    self.touxImage.userInteractionEnabled = YES;
    MYTapGestureRecognizer* tap1=[[MYTapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    tap1.nsString =imageUrl;
    tap1.imgeView= _touxImage;
    [self.touxImage addGestureRecognizer:tap1];
}

-(void)tap1:(MYTapGestureRecognizer*)sender{
    NSString * myStr =  sender.nsString;
    UIImageView * touxImg = sender.imgeView;
 
    NSMutableArray *items = @[].mutableCopy;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
    
    YSPhotoItem *item3 = [[YSPhotoItem alloc] initWithSourceView:touxImg imageUrl:[NSURL URLWithString:myStr]];
    [items addObject:item3];


    [YSPhotoBrowser showBrowserWithPhotoItems:items selectedIndex:0 imageLongPressStyleTitles:@[@"取消"] browserAlertSheetBlock:^(NSInteger imagePageIndex, NSInteger alertSheetType, UIImage * _Nullable image, NSString * _Nullable imageUrl) {
              if (alertSheetType == 0) {
                  NSLog(@"保存图片");
              }else if (alertSheetType == 1){
                  NSLog(@"转发图片");
              }else{
                  NSLog(@"取消");
              }
          }];
}

@end

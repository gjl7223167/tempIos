//
//  AlterPassViewController.m
//  ShuwxApp
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "AlterPassViewController.h"
#import "WRNavigationBar.h"



@interface AlterPassViewController ()

@end

@implementation AlterPassViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AlterPassViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AlterPassViewController"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.title = @"修改密码";
    
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
    [_subButton addTarget:self action:@selector(subButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_myNewPass resignFirstResponder];
    [_myNewPassTwo resignFirstResponder];
      [_myOldPass resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)subButtonClick{
    
    NSString * myNewPassText =  _myNewPass.text;
    if ([self isBlankString:myNewPassText]) {
        [self showToast:@"旧密码不能为空"];
        return;
    }
    NSString * myNewPassTwoText =  _myNewPassTwo.text;
    if ([self isBlankString:myNewPassTwoText]) {
        [self showToast:@"新密码不能为空"];
        return;
    }
    
    if ([myNewPassTwoText length] < 6) {
        [self showToast:@"新密码最少6位"];
        return;
    }
    if ([myNewPassTwoText length] > 20) {
        [self showToast:@"新密码最大20位"];
        return;
    }
    
    NSString * myOldPassText =  _myOldPass.text;
    if ([self isBlankString:myOldPassText]) {
        [self showToast:@"确认密码不能为空"];
        return;
    }
 
    if (![self getNSStringEqual:myOldPassText :myNewPassTwoText]) {
        [self showToast:@"新密码不一致"];
        return;
    }
    
    NSMutableDictionary * nsMuDic =   [self queryData];
     NSString *ptoken = [nsMuDic objectForKey:@"ptoken"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
//      CocoaSecurityResult *oldmd5Pass = [CocoaSecurity md5:myNewPassText];
//    CocoaSecurityResult *newmd5Pass = [CocoaSecurity md5:myOldPassText];
    
    NSString *oldmd5Pass = [SecurityUtility sha256HashFor:myOldPassText];
    oldmd5Pass = [oldmd5Pass lowercaseString];
    
    NSString *newmd5Pass = [SecurityUtility sha256HashFor:myNewPassText];
       newmd5Pass = [newmd5Pass lowercaseString];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:oldmd5Pass forKey:@"pwdOld"];
     [diction setValue:newmd5Pass forKey:@"pwdNew"];
     [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
//     [self clearCookie];
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :userUpdatePwd];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setConfirmAlarmMsg:myResult];
        }
        if ([myResult isKindOfClass:[NSString class]]) {
          int  myCode  = [[responseObject objectForKey:@"code"] intValue];
            if (myCode == 200) {
                self.myNewPass.text = @"";
                self.myNewPassTwo.text = @"";
                self.myOldPass.text = @"";
            }
            [self showToastTwo:myResult];
          
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setConfirmAlarmMsg:(NSMutableDictionary *) nsArr{
    
}



@end

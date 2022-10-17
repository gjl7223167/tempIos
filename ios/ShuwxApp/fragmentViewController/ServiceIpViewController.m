//
//  ServiceIpViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/22.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "ServiceIpViewController.h"
#import <UMCommon/MobClick.h>

@interface ServiceIpViewController ()

@end

@implementation ServiceIpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ServiceIpViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ServiceIpViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self.saveBtn addTarget:self action:@selector(toNext) forControlEvents:UIControlEventTouchUpInside];
    
      self.serviceCotent.returnKeyType = UIReturnKeyDone;
    self.serviceCotent.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上view可以换成任意一个控件的
    [self.backClick addGestureRecognizer:tapGestureRecognizer];
    
    //关键语句
    self.saveBtn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
//    self.saveBtn.layer.borderColor = [UIColor blackColor];//设置边框颜色
//    self.saveBtn.layer.borderWidth = 1.0f;//设置边框颜色
    
    
    self.serviceCotent.text = self.companyName;

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.serviceCotent resignFirstResponder];//textFiled是指您声明的UITextFiled控件的
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)getUserList{
    
    NSString * serText = self.serviceCotent.text;
    if ([self isBlankString:serText]) {
        [self showToast:@"请输入企业全称"];
        return;
    }
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    //    [diction setValue:@"我是一名好程序员23" forKey:@"companyName"];
    [diction setValue:serText forKey:@"companyName"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :getCompanyInfoTwo];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setUserList:myResult];
        }
        if ([myResult isKindOfClass:[NSString class]]) {
           [self showToast:myResult];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setUserList:(NSMutableDictionary *)dicnAry{
    CompanyInfoOkViewController * loginViewC = [[CompanyInfoOkViewController alloc] init];
    loginViewC.dicTable = dicnAry;
    [UIApplication sharedApplication].keyWindow.rootViewController = loginViewC;
}
-(void)toNext{
    [self getUserList];
}

@end

//
//  RebootOrderViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "RebootOrderViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

#import <UMCommon/MobClick.h>

@interface RebootOrderViewController ()

@end

@implementation RebootOrderViewController

-(NSMutableDictionary *)mydiction{
    if (!_mydiction) {
        _mydiction = [NSMutableDictionary dictionary];
    }
    return _mydiction;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"挂单重启";
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
    [MobClick beginLogPageView:@"RebootOrderViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RebootOrderViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    self.cqValue.placeholder = @"请填写重启理由（必填）";
    
  [self.reBtnMe addTarget:self action:@selector(reMeAction:) forControlEvents:(UIControlEventTouchUpInside)];
     [self.reBtnNew addTarget:self action:@selector(reNewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
      [self.rebootSubmit addTarget:self action:@selector(setRebootSubmit) forControlEvents:UIControlEventTouchUpInside];
    
         [self.selectPerson addTarget:self action:@selector(setSelectPerson) forControlEvents:UIControlEventTouchUpInside];
    
    self.reBtnMe.selected = YES;
          self.reBtnNew.selected = NO;
    selectId = 1;
    
    [self mydiction];
    
   [QTSub(self, MyEventBus) next:^(MyEventBus *event) {
             NSString * myErrorId =   event.errorId;
            if ([self getNSStringEqual:myErrorId:@"RebootOrderViewController"]) {
                self.mydiction =   event.diction;
                  NSString * rebootNamee = [self.mydiction objectForKey:@"name"];

                   [self.selectPerson setTitle:rebootNamee forState:UIControlStateNormal];
              }
           }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
         //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
         tapGestureRecognizer.cancelsTouchesInView = NO;
         //将触摸事件添加到view上
         [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.cqValue resignFirstResponder];
  
}


-(void)setSelectPerson{
    RebootDeptViewController * transferSelect = [[RebootDeptViewController alloc] init];
        transferSelect.order_id = self.order_id;
       [self.navigationController pushViewController:transferSelect  animated:YES];
    
    self.reBtnNew.selected = YES;
          self.reBtnMe.selected = NO;
    selectId = 2;
}
-(void)setRebootSubmit{
    NSString * titleStr = @"确定重启工单?";
//    titleStr =  [self getPinjieNSString:titleStr:@"?"];
      CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:titleStr];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            NSLog(@"点击了 %@ 按钮",action.title);
        }];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            NSLog(@"点击了 %@ 按钮",action.title);
            
            [self getRebootOrder];
            
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];
}
- (void)reMeAction:(UIButton *)button{
    self.reBtnMe.selected = YES;
            self.reBtnNew.selected = NO;
            selectId = 1;
}
- (void)reNewAction:(UIButton *)button
{
   self.reBtnNew.selected = YES;
                self.reBtnMe.selected = NO;
          selectId = 2;
}





-(void)getRebootOrder{
    
    NSString * guadString = self.cqValue.text;
    
    if ([self isBlankString:guadString]) {
          [self showToast:@"请填写转交理由!"];
          return;
      }
     NSString * curString =  self.selectPerson.currentTitle;
    if (selectId == 2 && [self getNSStringEqual:curString:@"请选择"]) {
        [self showToast:@"请选择转交人！"];
        return;
    }
    
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
       [diction setValue:@(selectId) forKey:@"sign"];
    [diction setValue:guadString forKey:@"content"];
    if (selectId == 2) {
        int rebootId = [[self.mydiction objectForKey:@"id"] intValue];
         [diction setValue:@(rebootId) forKey:@"next_man"];
    }
      
      
      NSString * url = [self getPinjieNSString:baseUrl :rebootOrderInfo];
      
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
                     [self setRebootOrder];
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
-(void)setRebootOrder{
    MyEventBus * myEvent = [[MyEventBus alloc] init];
          myEvent.errorId = @"WorkDetailsViewController";
             [[QTEventBus shared] dispatch:myEvent];
    
    
                                                [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
                                                                                  
                                                                                   [self showToast:@"操作完成"];
}

@end

//
//  ScanloginResultViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/10/14.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "ScanloginResultViewController.h"
#import "WRNavigationBar.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "AppDelegate.h"

@interface ScanloginResultViewController ()

@end

@implementation ScanloginResultViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
      [_cancelBtn addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    
    [_resultqr addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * text = @"登录信息已过期，请重新尝试登录";
    
    _qrrefresh.numberOfLines = 0;//表示label可以多行显示
    
    //设置字间距
    NSDictionary *dic = @{NSKernAttributeName:@1.f};
    NSMutableAttributedString * attributedString =     [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]     init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:10];//行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [_qrrefresh setAttributedText:attributedString];
    [_qrrefresh sizeToFit];
}
-(void)setScan{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
           [appDelegate toShowTwo];
}

-(void)onClickLeft{
    
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [self openScanVCWithStyle:[StyleDIY ZhiFuBaoStyle]];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    DIYScanViewController * vc = [DIYScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end

//
//  SeeSetViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SeeSetViewController.h"
#import "WRNavigationBar.h"
#import "NSUserDefaultUtil.h"

#import <UMCommon/MobClick.h>

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 230


@interface SeeSetViewController ()

@end

@implementation SeeSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SeeSetViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SeeSetViewController"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, 50);
    self.twoView.frame = CGRectMake(0,NAV_HEIGHT +50,SCREEN_WIDTH, 120);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.navigationItem.title = @"可视化设置";
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
    
    self.hpView.userInteractionEnabled=YES;
      UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHpView)];
     [self.hpView addGestureRecognizer:ggggg];
    
    self.spView.userInteractionEnabled=YES;
      UITapGestureRecognizer *sptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSpView)];
     [self.spView addGestureRecognizer:sptap];
    
    self.zyView.userInteractionEnabled=YES;
      UITapGestureRecognizer *zyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setZyView)];
     [self.zyView addGestureRecognizer:zyTap];
    
   NSString * setintString =  [NSUserDefaultUtil GetDefaults:@"setint"];
    if ([self isBlankString:setintString]) {
        setintString = @"2";
    }
    int setint = [setintString intValue];
    if (setint == 1) {
        [self setHpView];
    }
    if (setint == 2) {
        [self setSpView];
    }
    if (setint == 3) {
        [self setZyView];
    }
    
}
-(void)setHpView{
    [_hpImgSelect setImage:[UIImage imageNamed:@"syselect"]];
    [_spImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [_zyImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [NSUserDefaultUtil PutDefaults:@"setint" Value:@"1"];
}
-(void)setSpView{
    [_hpImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [_spImgSelect setImage:[UIImage imageNamed:@"syselect"]];
    [_zyImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [NSUserDefaultUtil PutDefaults:@"setint" Value:@"2"];
}
-(void)setZyView{
    [_hpImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [_spImgSelect setImage:[UIImage imageNamed:@"syselectno"]];
    [_zyImgSelect setImage:[UIImage imageNamed:@"syselect"]];
    [NSUserDefaultUtil PutDefaults:@"setint" Value:@"3"];
}



-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

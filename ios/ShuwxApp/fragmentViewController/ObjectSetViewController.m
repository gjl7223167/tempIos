//
//  ObjectSetViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2021/4/26.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "ObjectSetViewController.h"
#import "WRNavigationBar.h"
#import <UMCommon/MobClick.h>
#import "NSUserDefaultUtil.h"

@interface ObjectSetViewController ()

@end

@implementation ObjectSetViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.topView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, 50);
    self.objectView.frame = CGRectMake(0,NAV_HEIGHT +51,SCREEN_WIDTH, 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"对象列表设置";
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
    
    [self.objectListButton addTarget:self action:@selector(reMeAction:) forControlEvents:(UIControlEventTouchUpInside)];
       [self.objectMapButton addTarget:self action:@selector(reNewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ObjectSetViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ObjectSetViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    NSString * setintString =  [NSUserDefaultUtil GetDefaults:@"objectint"];
    if ([self isBlankString:setintString]) {
        setintString = @"1";
    }
    int setint = [setintString intValue];
    if (setint == 1) {
        [self setObjectListView];
    }
    if (setint == 2) {
        [self setObjectMapView];
    }
}
-(void)setObjectListView{
    self.objectListButton.selected = YES;
            self.objectMapButton.selected = NO;
}
-(void)setObjectMapView{
    self.objectMapButton.selected = YES;
                 self.objectListButton.selected = NO;
}

- (void)reMeAction:(UIButton *)button{
    [self setObjectListView];
    [NSUserDefaultUtil PutDefaults:@"objectint" Value:@"1"];
}
- (void)reNewAction:(UIButton *)button
{
    [self setObjectMapView];
    [NSUserDefaultUtil PutDefaults:@"objectint" Value:@"2"];
         
}

@end

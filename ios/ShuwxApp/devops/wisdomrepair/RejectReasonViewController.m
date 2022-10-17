//
//  RejectReasonViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "RejectReasonViewController.h"
#import "WRNavigationBar.h"
#import <UMCommon/MobClick.h>


@interface RejectReasonViewController ()

@end

@implementation RejectReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
              self.navigationItem.title = @"驳回原因";
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
    [MobClick beginLogPageView:@"RejectReasonViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RejectReasonViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
  
}



@end

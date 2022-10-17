//
//  BusnessStatisViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/17.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BusnessStatisViewController.h"
#import "SGPagingView.h"
#import "WRNavigationBar.h"

@interface BusnessStatisViewController ()

@end

@implementation BusnessStatisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1.0];
           self.navigationItem.title = @"业务统计";
          
           //    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
           
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
           
       //    UIButton  *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
       //    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       //    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
       //    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
       //    [rightButton setImage:[UIImage imageNamed:@"shuaix"] forState:UIControlStateNormal];
       //    [rightButton addTarget:self action:@selector(toPopWin) forControlEvents:UIControlEventTouchUpInside];
       //    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左显示
       //    [rightButton setFrame:CGRectMake(0,0,60,40)];
       //
       //    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
       //    rightBarButton.enabled = YES;
       //    self.navigationItem.rightBarButtonItem = rightBarButton;
           
           // 设置导航栏颜色
         [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
           
           // 设置初始导航栏透明度
           [self wr_setNavBarBackgroundAlpha:1];
           
           // 设置导航栏按钮和标题颜色
           [self wr_setNavBarTintColor:[UIColor whiteColor]];
           [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    [self initViwe];
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


-(void)initViwe{
    
      [self.orderCarryOutBtn addTarget:self action:@selector(setOrderCarryOut) forControlEvents:UIControlEventTouchUpInside];
       [self.orderBankBtn addTarget:self action:@selector(setOrderBank) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)setOrderCarryOut{
    OrderCompleteViewController * waitOrder = [OrderCompleteViewController new];
                 [self.navigationController pushViewController:waitOrder animated:YES];
}
-(void)setOrderBank{
    OrderTypeRankViewController * orderType = [OrderTypeRankViewController new];
     [self.navigationController pushViewController:orderType animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BusnessStatisViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BusnessStatisViewController"];
}


-(void)setScan{
     [self.navigationController popViewControllerAnimated:YES];
}

@end

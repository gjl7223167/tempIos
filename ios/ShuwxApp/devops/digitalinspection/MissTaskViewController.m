//
//  MissTaskViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MissTaskViewController.h"
#import "SGPagingView.h"
#import "WRNavigationBar.h"



@interface MissTaskViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@end

@implementation MissTaskViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MissTaskViewController"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MissTaskViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSMutableArray *)childArr{
    if (!_childArr) {
        _childArr = [NSMutableArray array];
    }
    return _childArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1.0];
         self.navigationItem.title = @"漏检任务审核";
         
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
         
      
       [self childArr];
         [self setupSystem];
}


- (void)setupSystem {
      
    NSArray *titleArr = @[@"待审核", @"已审核"];
      SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
      configure.indicatorAdditionalWidth = 0; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
      configure.titleGradientEffect = YES;
      
      configure.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
      configure.titleSelectedColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
      configure.indicatorColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
      configure.titleFont = [UIFont systemFontOfSize:15];
      
      /// pageTitleView
      self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 44) delegate:self titleNames:titleArr configure:configure];
      [self.view addSubview:_pageTitleView];
    
      self.pageTitleView.selectedIndex = 0;
    
    ReviewIngViewController * oneView = [[ReviewIngViewController alloc] init];
              [self.childArr addObject:oneView];
    
    ReviewEndViewController * Twoview = [[ReviewEndViewController alloc] init];
                 [self.childArr addObject:Twoview];
    

    
    CGFloat ContentCollectionViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(_pageTitleView.frame);
     self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), SCREEN_WIDTH, ContentCollectionViewHeight) parentVC:self childVCs:self.childArr];
     self.pageContentScrollView.delegatePageContentScrollView = self;
     [self.view addSubview:self.pageContentScrollView];
}
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}
- (void)changeSelectedIndex:(NSNotification *)noti {
    self.pageTitleView.resetSelectedIndex = [noti.object intValue];
}
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 0) {
        [self.pageTitleView removeBadgeForIndex:index];
    }
}


-(void)setScan{
     [self.navigationController popViewControllerAnimated:YES];
}
@end

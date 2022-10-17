//
//  CarLogoViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "CarLogoViewController.h"
#import "WRNavigationBar.h"



@interface CarLogoViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@end

@implementation CarLogoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CarLogoViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CarLogoViewController"];
}

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择车标";
    
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
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self childArr];
    [self titleArr];
     [self setupSystem];
}

- (void)setupSystem {
    
    [self.titleArr addObject:@"国内"];
     [self.titleArr addObject:@"国外"];
    CarLogoItemViewController * allAnalyzeView = [[CarLogoItemViewController alloc] init];
            allAnalyzeView.carType =@"0";
            allAnalyzeView.returnValueBlock =_returnValueBlock;
    
    [self.childArr addObject:allAnalyzeView];
    
    CarLogoItemViewController * allAnalyzeViewTwo = [[CarLogoItemViewController alloc] init];
           allAnalyzeViewTwo.carType =@"1";
           allAnalyzeViewTwo.returnValueBlock =_returnValueBlock;
    
    [self.childArr addObject:allAnalyzeViewTwo];
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 74;
    } else {
        pageTitleViewY = 88;
    }
    CGFloat pageTitleViewW = 200;
    CGFloat pageTitleViewX = 0.5 * (SCREEN_WIDTH - pageTitleViewW);
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    configure.titleSelectedColor = [UIColor whiteColor];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.showBottomSeparator = NO;
    configure.indicatorStyle = SGIndicatorStyleCover;
    configure.indicatorColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    configure.indicatorHeight = 30;
    configure.indicatorAdditionalWidth = 120; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.showVerticalSeparator = NO;
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(pageTitleViewX, pageTitleViewY + 10, pageTitleViewW, 30) delegate:self titleNames:self.titleArr configure:configure];
    _pageTitleView.layer.borderWidth = 1;
    _pageTitleView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _pageTitleView.layer.cornerRadius = 5;
    _pageTitleView.layer.masksToBounds = YES;
    [self.view addSubview:_pageTitleView];
    
    CGFloat ContentCollectionViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame) + 10, SCREEN_WIDTH, ContentCollectionViewHeight - 10) parentVC:self childVCs:self.childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object intValue];
}


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    myPostion = index;
    if (index == 0) {
        [_pageTitleView removeBadgeForIndex:index];
    }
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"DefaultScrollVC - - dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end

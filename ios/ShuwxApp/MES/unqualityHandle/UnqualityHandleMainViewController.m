//
//  UnqualityHandleMainViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/29.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityHandleMainViewController.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "SGPagingView.h"

#import "SearchViewController.h"

#import "StyleDIY.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "MESScanViewController.h"

#import "UnqualityHandleListViewController.h"


@interface UnqualityHandleMainViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property(nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *childArr;

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation UnqualityHandleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    //    SGPageTitleView
    [self getTitleData];
}

-(NSMutableArray *)childArr{
    if (!_childArr) {
        _childArr = [NSMutableArray array];
    }
    return _childArr;
}

-(void)setNavi
{
    self.navigationItem.title = @"不合格处理单";
    self.view.backgroundColor = [UIColor whiteColor];
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

    UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton1 setImage:[UIImage imageNamed:@"saoone"] forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(saoyisao) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton1 setFrame:CGRectMake(0,0,40,40)];
//    [rightButton1 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//    rightButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"sousuoone"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(sousuoClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton1, rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saoyisao
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openScanVCWithStyle:[StyleDIY ZhiFuBaoStyle]];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    MESScanViewController *vc = [MESScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.scanType = scanUnqualityHandleMain;
    vc.titleArr = self.titleArr;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)sousuoClick
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchUnqualityHandleMain;
    NSDictionary *dic = self.titleArr[self.pageTitleView.selectedIndex];
    vc.paramStr = dic[@"id"];
    vc.paramSubStr = dic[@"dic_code"];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)getTitleData
{
    WS(weakSelf)
    [UrlRequest requestUnqualityHandleStatusWithParam:nil completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
            if (dataArr.count > 0) {
                weakSelf.titleArr = dataArr;
                
                [weakSelf setupMain];
            }
        }
    }];
}


- (void)setupMain{
    NSMutableArray *titleArr = [[NSMutableArray alloc] initWithCapacity:5];

    for (NSDictionary *dic in self.titleArr) {
        
        [titleArr addObject:dic[@"dic_name"]];
        UnqualityHandleListViewController *oneView = [[UnqualityHandleListViewController alloc] init];
        oneView.statusDic = dic;
        oneView.titleArr = self.titleArr;
        [self.childArr addObject:oneView];
    }
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
    
    
    CGFloat ContentCollectionViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(_pageTitleView.frame);
     self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), SCREEN_WIDTH, ContentCollectionViewHeight) parentVC:self childVCs:self.childArr];
     _pageContentScrollView.delegatePageContentScrollView = self;
     [self.view addSubview:_pageContentScrollView];
}
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}
- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object intValue];
}
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    self.pageTitleView.selectedIndex = targetIndex;
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 0) {
        [_pageTitleView removeBadgeForIndex:index];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

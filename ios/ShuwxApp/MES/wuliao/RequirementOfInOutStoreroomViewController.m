//
//  RequirementOfInOutStoreroomViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/15.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "RequirementOfInOutStoreroomViewController.h"
#import "WRNavigationBar.h"
#import "SearchViewController.h"
#import "SGPagingView.h"
#import "UrlRequest.h"

#import "ModelInOutStoreRequireMainViewController.h"

@interface RequirementOfInOutStoreroomViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic,strong) UISegmentedControl *segmentedControl;

@property(nonatomic,strong)NSArray *inTitleArr;
@property(nonatomic,strong)NSArray *outTitleArr;

@property (nonatomic,strong) NSMutableArray *childArr;

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;


@end

@implementation RequirementOfInOutStoreroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    
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
//    self.navigationItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.segmentedControl;
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
    
    [self wr_setNavBarBarTintColor:[self colorWithHexString:@"#0089ff"]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"sousuoone"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(sousuoClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sousuoClick
{
    if (self.childArr.count == 0) {
        return;
    }
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchModelInOutStoreRequireMain;
    ModelInOutStoreRequireMainViewController *InOutvc = self.childArr[self.pageTitleView.selectedIndex];
    vc.paramStr = [NSString stringWithFormat:@"%@",InOutvc.titleDic[@"id"]];
    vc.paramSubStr = InOutvc.titleDic[@"dic_code"];
    vc.isInStore = InOutvc.isInStore;
    [self.navigationController pushViewController:vc animated:NO];
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        NSArray *segArr = [NSArray arrayWithObjects:@"入库需求",@"出库需求", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segArr];
        _segmentedControl.frame = CGRectMake(0, 0, 230, 32);
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
        if (@available(iOS 13.0, *)) {
//            _segmentedControl.selectedSegmentTintColor = RGBA(0, 137, 255, 1);
        } else {
            // Fallback on earlier versions
        }
        _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segmentedControl.layer.borderWidth = 1;
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBA(0, 137, 255, 1)} forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

//        _segmentedControl.tintColor = [UIColor whiteColor];
    }
    
    return _segmentedControl;
}

-(void)segChange:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        NSLog(@"-----0--------");
        
        for (int i = 0; i < self.childArr.count; i++) {
            ModelInOutStoreRequireMainViewController *vc = self.childArr[i];
            vc.isInStore = YES;
            vc.titleDic = self.inTitleArr[i];
        }
    }else
    {
        NSLog(@"-----1--------");
        for (int i = 0; i < self.childArr.count; i++) {
            ModelInOutStoreRequireMainViewController *vc = self.childArr[i];
            vc.isInStore = NO;
            vc.titleDic = self.outTitleArr[i];
        }
    }
    
    if (self.childArr.count == 0) {
        return;
    }
    ModelInOutStoreRequireMainViewController *vc = self.childArr[self.pageTitleView.selectedIndex];
    [vc updateStoreData];
}

-(void)getTitleData
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    @"IOM_materialrequire_r",@"dic_type",
    nil];
    
    [UrlRequest requestSelectDictionaryByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
            if (dataArr.count > 0) {
                [dataArr removeLastObject];
                self.inTitleArr = dataArr;
                
                [self setupMain];
            }
            
        }

    }];
    
    param = [NSDictionary dictionaryWithObjectsAndKeys:
    @"IOM_materialrequire_c",@"dic_type",
    nil];
    
    [UrlRequest requestSelectDictionaryByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
            if (dataArr.count > 0) {
                [dataArr removeLastObject];
                self.outTitleArr = dataArr;
            }
        }
    }];
}


- (void)setupMain{
    NSMutableArray *titleArr = [[NSMutableArray alloc] initWithCapacity:5];

//    {
//        "dic_code" = "IOM_materialrequire_r_01";
//        "dic_name" = "\U672a\U5f00\U59cb";
//        "dic_type" = "IOM_materialrequire_r";
//        id = 854;
//        "is_enable" = 1;
//        "is_type" = 0;
//        remark = 1;
//        sort = 1;
//    }
    for (NSDictionary *dic in self.inTitleArr) {
        [titleArr addObject:dic[@"dic_name"]];
        ModelInOutStoreRequireMainViewController *oneView = [[ModelInOutStoreRequireMainViewController alloc] init];
        oneView.titleDic = dic;
        oneView.isInStore = YES;
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
    self.pageTitleView.selectedIndex = selectedIndex;
    
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object intValue];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
//    if (index == 0) {
//        [_pageTitleView removeBadgeForIndex:index];
//    }
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

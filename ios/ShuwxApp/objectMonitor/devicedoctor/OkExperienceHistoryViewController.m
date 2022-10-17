//
//  OkExperienceHistoryViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/10/9.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "OkExperienceHistoryViewController.h"
#import "SGPagingView.h"
#import "WRNavigationBar.h"
#import "WebViewController.h"




@interface OkExperienceHistoryViewController ()<SGPageTitleViewDelegate,SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (strong, nonatomic) WebViewController *twoVC;
@end

@implementation OkExperienceHistoryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OkExperienceHistoryViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OkExperienceHistoryViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.navigationItem.title = @"确认报警";
    
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
    
    [self setupSystem];
}

-(void)setScan{
        [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)setupSystem {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    
    //    CGFloat pageTitleViewW = self.view.frame.size.width * 4 / 5;
    //    CGFloat pageTitleViewX = 0.5 * (self.view.frame.size.width - pageTitleViewW);
    NSArray *titleArr = @[@"报警确认", @"历史经验"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = [UIColor whiteColor];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.showBottomSeparator = NO;
    configure.verticalSeparatorColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    configure.indicatorStyle = SGIndicatorStyleCover;
    configure.indicatorColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    configure.indicatorHeight = 30;
    configure.indicatorAdditionalWidth = 120; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.showVerticalSeparator = YES;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(SCREEN_WIDTH/2 -100, NAV_HEIGHT + 10, 180, 25) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.layer.borderWidth = 1;
    self.pageTitleView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1].CGColor;
    self.pageTitleView.layer.cornerRadius = 5;
    self.pageTitleView.layer.masksToBounds = YES;
    
    
    [self.view addSubview:self.pageTitleView];
    self.pageTitleView.selectedIndex = 0;
    
    NSMutableDictionary * dicnary = [self queryData];
            NSString *ptoken = [dicnary objectForKey:@"ptoken"];
         
         NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
          int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
        NSString *appVersion = [NSString stringWithFormat:@"%d", app_Version];
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * h5Base = [defaults objectForKey:@"h5Base"];

         
         NSString * first = [self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:@"?token=":ptoken]:[self getPinjieNSString:@"&msg_id=":self.msg_id]]:[self getPinjieNSString:@"&create_time=":self.create_time]]:[self getPinjieNSString:@"&alarm_level=":self.workStatus]]:[self getPinjieNSString:@"&version_code=":appVersion]]:@"&is_his=0"];
         
          first =  [first stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
        NSString * webUrl =  [self getPinjieNSString:h5Base:[self getPinjieNSString:historyExperience:first]];
         
         self.twoVC = [[WebViewController alloc] init];
         self.twoVC.htmlContent = webUrl;
         self.twoVC.webTitle = @"历史经验";
       //   [self.navigationController pushViewController:self.twoVC  animated:YES];
    
    self.oneVC = [[FaultOkViewController alloc] init];
     self.oneVC.msg_id = self.msg_id;
    self.oneVC.workStatus = self.workStatus;
    
    NSArray *childArr = @[self.oneVC, self.twoVC];
    
    CGFloat ContentCollectionViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 40, SCREEN_WIDTH, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
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
- (void)dealloc {
    NSLog(@"DefaultScrollVC - - dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end

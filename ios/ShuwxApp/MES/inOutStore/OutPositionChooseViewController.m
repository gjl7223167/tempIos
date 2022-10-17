//
//  OutPositionChooseViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/8.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "OutPositionChooseViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

@interface OutPositionChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *recommendDataArr;

@end

@implementation OutPositionChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    [self.view addSubview:self.myTableView];
    [self getRecommendPositionData];
    
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataArr;
}

- (NSMutableArray *)recommendDataArr
{
    if (!_recommendDataArr) {
        _recommendDataArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _recommendDataArr;
}


-(void)setNavi
{
    self.title = @"选择出库位置";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
    [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
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
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchOutPositionChoose;
    vc.paramDic = self.dataDic;
    vc.SearchBackB = ^(NSDictionary *  _Nullable dic) {
        
        if (self.OutPositionBack) {
            self.OutPositionBack(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)getOutPositionChooseData
{
    NSString *batchNo = self.dataDic[@"batchNo"];
    if([batchNo isKindOfClass:[NSNull class]])
    {
        batchNo = @"";
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    self.dataDic[@"materialId"],@"materialId",
    batchNo,@"batchNo",
    @"",@"name",
    nil];
    [UrlRequest requestOutStorePositionWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];
    }];
}

-(void)getRecommendPositionData
{
    NSString *batchNo = self.dataDic[@"batchNo"];
    if([batchNo isKindOfClass:[NSNull class]])
    {
        batchNo = @"";
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.dataDic[@"materialId"],@"materialId",
                            batchNo,@"batchNo",
                            nil];
    [UrlRequest requestOutRecommendPositionWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
           if (result) {
               [self.recommendDataArr addObjectsFromArray:data];
           }
        
        [self getOutPositionChooseData];

       }];
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kTopSafeAreaHeight + kStatusBarHeight + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.recommendDataArr.count;
    }
    return self.dataArr.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *iden = @"iden";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    if (indexPath.section == 0) {
        NSDictionary *dic = self.recommendDataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@   库存数量%@个",dic[@"positionName"],dic[@"qty"]];
    }else{
        NSDictionary *dic = self.dataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@   库存数量%@个",dic[@"positionName"],dic[@"qty"]];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = self.recommendDataArr[indexPath.row];
    }
    else{
        dic = self.dataArr[indexPath.row];
    }
    
    if (self.OutPositionBack) {
        self.OutPositionBack(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *infoStr = [NSString stringWithFormat:@"全部"];
    if (section == 0) {
        infoStr = [NSString stringWithFormat:@"推荐出库位置"];
    }
    return [self getHeaderV:infoStr rightStr:nil rightSel:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  55.0f;
}

-(UIView *)getHeaderV:(NSString *)leftStr rightStr:(NSString *)rightS rightSel:(NSString *)rightSel
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, 12, 4, 16)];
    view1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1];
    [bottomV addSubview:view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 180, 20)];
    label.text = leftStr;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    if (rightS) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightS forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(bottomV.frame.size.width - 60 - 16, 5, 60, 30);
        SEL sel = NSSelectorFromString(rightSel);
        [rightBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:rightBtn];
    }
    
    
    return currentState;
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

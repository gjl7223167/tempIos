//
//  StorePositionChooseViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/3.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StorePositionChooseViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "PositionLeftTableViewCell.h"
#import "PositionRightTableViewCell.h"
#import "noDataShowTableViewCell.h"

@interface StorePositionChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *leftTableView;
@property (strong, nonatomic) BaseTableView *rightTableView;

@property (strong, nonatomic) NSArray *leftArr;
@property (strong, nonatomic) NSArray *rightArr;


@end

@implementation StorePositionChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    self.leftArr = @[];
    self.rightArr = @[];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self getLeftCategoryData];
    [self getRecommendPosition];
}

-(void)setNavi
{
    self.title = @"选择入库位置";

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
//    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
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
    vc.searchFrom = searchStorePositionChoose;
    vc.SearchBackB = ^(NSDictionary *  _Nullable dic) {
        
        if (self->_PositionBack) {
            self->_PositionBack(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)getLeftCategoryData
{
    [UrlRequest requestStoreRequireLeftWithParam:nil completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            self.leftArr = [NSArray arrayWithArray:data];
            [self.leftTableView reloadData];
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            PositionLeftTableViewCell *cell = [self.leftTableView cellForRowAtIndexPath:index];
            [cell setSelected:YES animated:YES];
        }
    }];
}

-(void)getRecommendPosition
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.materialId,@"id",
                            nil];
    [UrlRequest requestRecommendStoreRequirePosWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            if (![data isKindOfClass:[NSNull class]]) {
                self.rightArr = [NSArray arrayWithArray:data];
            }
            else{
                self.rightArr = @[];
            }
            [self.rightTableView reloadData];

        }
    }];
}

-(void)getRightPositionData:(NSString *)categoryId
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            categoryId,@"id",
                            nil];
    [UrlRequest requestStoreRequirePosWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            if (![data isKindOfClass:[NSNull class]]){
                self.rightArr = [NSArray arrayWithArray:data];
                [self.rightTableView reloadData];
            }
            
        }
    }];
}

- (BaseTableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kTopSafeAreaHeight + kStatusBarHeight + 20, 107, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStylePlain];
//        _leftTableView.sectionFooterHeight = 0.01;
//        _leftTableView.sectionHeaderHeight = 0.01;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        _leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _leftTableView.alwaysBounceVertical = NO;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _leftTableView;
}

- (BaseTableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(107, kTopSafeAreaHeight + kStatusBarHeight + 20, self.view.frame.size.width - 107, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStylePlain];
        
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.alwaysBounceVertical = NO;
//        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        return self.leftArr.count + 1;
    }
    if (self.rightArr.count == 0) {
        return 1;
    }
    return self.rightArr.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        
        PositionLeftTableViewCell *cell = [PositionLeftTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"推荐库位";
        }else
        {
            NSDictionary *dic = self.leftArr[indexPath.row - 1];
            cell.titleLabel.text = dic[@"name"];
        }
        
        return cell;
    }
    else
    {
        if (self.rightArr.count == 0) {
            noDataShowTableViewCell *cell = [noDataShowTableViewCell cellWithTableView:tableView];
            return cell;
        }
        PositionRightTableViewCell *cell = [PositionRightTableViewCell cellWithTableView:tableView];
        NSDictionary *dic = self.rightArr[indexPath.row];
        cell.titleLabel.text = dic[@"name"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView){
        return 50.0;
    }else{
        if (self.rightArr.count == 0) {
            return self.view.frame.size.height - 88;
        }else{
            return 50.0;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.leftTableView) {
        if (indexPath.row == 0) {
            [self getRecommendPosition];
        }else
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            PositionLeftTableViewCell *cell = [self.leftTableView cellForRowAtIndexPath:index];
            [cell setSelected:NO animated:YES];
            
            NSDictionary *dic = self.leftArr[indexPath.row - 1];
            [self getRightPositionData:[NSString stringWithFormat:@"%@",dic[@"id"]]];
        }
    }
    else
    {
        if (self.rightArr.count == 0) {
            return;
        }
        NSDictionary *dic = self.rightArr[indexPath.row];
        
        if (_PositionBack) {
            _PositionBack(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
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

//
//  OperatorListViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/5.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "OperatorListViewController.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "SearchViewController.h"
#import "BaseTableView.h"
#import "WorkOperatorModel.h"
#import <MJExtension.h>
#import "WorkOperatorTableViewCell.h"

@interface OperatorListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UIButton *rightBtn;

@property(nonatomic,strong) NSMutableArray *selectedArr;

@end

@implementation OperatorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.selectedArr = [[NSMutableArray alloc] initWithCapacity:10];
    [self.view addSubview:self.myTableView];
    [self bottomViewShow];
    [self getOperaterListData];
}

-(void)setNavi
{
    self.title = @"选择操作人";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
    [leftButton setImage:[UIImage imageNamed:@"mes_right_black"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"mes_black_sousuo"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(sousuoClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    NSArray *actionButtonItems = @[rightBarButton2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sousuoClick
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchOperatorList;
    vc.SearchBackB = ^(WorkOperatorModel *  _Nullable model) {
        for (WorkOperatorModel *Operatator in self.dataArr) {
            if ([model.myid intValue] == [Operatator.myid intValue]) {
                Operatator.isSelected = YES;
                if (![self.selectedArr containsObject:Operatator]) {
                    NSUInteger index = [self.dataArr indexOfObject:Operatator];
                    [self.selectedArr addObject:Operatator];
                    
                    if ([self judgeTotalChooseState]) {
                        self.leftImgV.highlighted = YES;
                    }
                    NSString *btnStr = [NSString stringWithFormat:@"提交(%ld)",self.selectedArr.count];
                    [self.rightBtn setTitle:btnStr forState:UIControlStateNormal];
                    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.myTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
            }
        }
    };
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)bottomViewShow
{
    UIView *bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        bottomV.frame = CGRectMake(0, self.view.frame.size.height - 74 - kBottomSafeAreaHeight, SCREEN_WIDTH, 74 + kBottomSafeAreaHeight);
    } else {
        // Fallback on earlier versions
        bottomV.frame = CGRectMake(0, self.view.frame.size.height - 74, SCREEN_WIDTH, 74);
    }
    [self.view addSubview:bottomV];
    
    UIView *leftV = [UIView new];
    leftV.frame = CGRectMake(0, 0, 100, 74);
    [bottomV addSubview:leftV];
    
    self.leftImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mes_circle_unselected"] highlightedImage:[UIImage imageNamed:@"mes_circle_selected"]];
    self.leftImgV.highlighted = NO;
    self.leftImgV.frame = CGRectMake(16, 27, 20, 20);
    [leftV addSubview:self.leftImgV];
    
    UILabel *label = [UILabel new];
    label.text = @"全选";
    label.textColor = RGBA(102, 102, 102, 1);
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(46, 25, 40, 24);
    [leftV addSubview:label];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 100, 74);
    [leftV addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(totalChoose) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 16 - 160, 12, 160, 50);
    self.rightBtn.backgroundColor = RGBA(0, 137, 255, 1);
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 3;
    [bottomV addSubview:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(submitOperators) forControlEvents:UIControlEventTouchUpInside];
}


-(void)getOperaterListData
{
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"",@"name",
                            nil];
    WS(weakSelf)
    [UrlRequest requestMaterialOperatorListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
//            mj_objectArrayWithKeyValuesArray
            NSArray *modelArr = [WorkOperatorModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf.dataArr addObjectsFromArray:modelArr];
            if (weakSelf.selectedOperatorArr&&weakSelf.selectedOperatorArr.count) {
                for (WorkOperatorModel *model in weakSelf.dataArr) {
                    for (WorkOperatorModel *opeModel in weakSelf.selectedOperatorArr) {
                        
                        if([opeModel.myid intValue] == [model.myid intValue])
                        {
                            model.isSelected = YES;
                            [weakSelf.selectedArr addObject:model];
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf judgeTotalChooseState]) {
                    weakSelf.leftImgV.highlighted = YES;
                    NSString *btnStr = [NSString stringWithFormat:@"提交(%ld)",weakSelf.selectedArr.count];
                    [weakSelf.rightBtn setTitle:btnStr forState:UIControlStateNormal];
                }
                [weakSelf.myTableView reloadData];
            });
        }
    }];
    
    
}



- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 20 + 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), self.view.frame.size.width, self.view.frame.size.height - 44 - kBottomSafeAreaHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
//        _myTableView.rowHeight = 50;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    WorkOperatorTableViewCell *cell = [WorkOperatorTableViewCell cellWithTableView:tableView];
    WorkOperatorModel *model = self.dataArr[indexPath.row];
    cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (model.isSelected) {
        cell.leftImgV.highlighted = YES;
    }
    else
    {
        cell.leftImgV.highlighted = NO;
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WorkOperatorModel *model = self.dataArr[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.selectedArr addObject:model];
    }
    else
    {
        [self.selectedArr removeObject:model];
    }
    if (self.selectedArr.count) {
        NSString *btnStr = [NSString stringWithFormat:@"提交(%ld)",self.selectedArr.count];
        [self.rightBtn setTitle:btnStr forState:UIControlStateNormal];
        if ([self judgeTotalChooseState]) {
            self.leftImgV.highlighted = YES;
        }
        else
        {
            self.leftImgV.highlighted = NO;
        }
    }
    else
    {
        [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.leftImgV.highlighted = NO;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)totalChoose
{
    if ([self judgeTotalChooseState]) {
        [self.selectedArr removeAllObjects];

        for (WorkOperatorModel *mode in self.dataArr) {
            mode.isSelected = NO;
        }
        self.leftImgV.highlighted = NO;
        [self.myTableView reloadData];
        [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    else
    {
        [self.selectedArr removeAllObjects];
        [self.selectedArr addObjectsFromArray:self.dataArr];
        for (WorkOperatorModel *mode in self.dataArr) {
            mode.isSelected = YES;
        }
        self.leftImgV.highlighted = YES;
        [self.myTableView reloadData];
        NSString *btnStr = [NSString stringWithFormat:@"提交(%ld)",self.selectedArr.count];
        [self.rightBtn setTitle:btnStr forState:UIControlStateNormal];
        
    }
}

-(BOOL)judgeTotalChooseState
{
    if (self.selectedArr.count == self.dataArr.count) {
        return YES;
    }
    return NO;
}

-(void)submitOperators
{
    if (self.selectedArr.count) {
        if (_OperatorB) {
            _OperatorB(self.selectedArr);
            [self.navigationController popViewControllerAnimated:YES];
        }
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

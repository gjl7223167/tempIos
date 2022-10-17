//
//  DefectInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/24.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "DefectInfoViewController.h"
#import "BaseTableView.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "Tools.h"

#import "DefectInfoTableViewCell.h"

#import "AddDefectInfoViewController.h"

@interface DefectInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong,nonatomic) UIButton *submitBtn;

@end

@implementation DefectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];

    [self.view addSubview:self.myTableView];
    
    [self getInspectionInfoData];
}


-(void)setNavi
{
    self.title = @"缺陷信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    showback mes_back
    [leftButton setImage:[UIImage imageNamed:@"mes_right_black"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];
    
    if (!self.isDetail) {
        [self rightBarItem];
    }
}

-(void)rightBarItem
{
    UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"mes_add"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [rightButton2 setFrame:CGRectMake(0,0,40,40)];

    UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];

    self.navigationItem.rightBarButtonItem = rightBarButton2;
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArr;
}


- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(16, 20, SCREEN_WIDTH - 32, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(ModifyInspectionInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)getInspectionInfoData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.myId,@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestDefectInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.dataArr addObjectsFromArray:data];
        }
        [weakSelf.myTableView reloadData];

    }];
}


- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64 + 20, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
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
        
//        if (!self.isDetail) {
//            UIView *footerV = [[UIView alloc] init];
//            footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
//            footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
//            [footerV addSubview:self.submitBtn];
//            _myTableView.tableFooterView = footerV;
//        }
        
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArr.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.section];
    DefectInfoTableViewCell *cell = [DefectInfoTableViewCell cellWithTableView:tableView];
    cell.dataDic = dic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 273.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = [NSString stringWithFormat:@"信息%ld",section+1];
    return [self getHeaderV:title section:section];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  55.0f;
}


-(UIView *)getHeaderV:(NSString *)leftStr section:(NSInteger)section
{
    
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, 12, 4, 16)];
    view1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1];
    [bottomV addSubview:view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
    label.text = leftStr;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    
    if (!self.isDetail) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(bottomV.frame.size.width - 18 - 16, 10, 18, 20);
        rightBtn.tag = section + 100;
        [rightBtn setImage:[UIImage imageNamed:@"store_delete"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(deleteInfo:) forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:rightBtn];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(bottomV.frame.size.width - 18 - 16 - 18 - 20, 11, 18, 18);
        leftBtn.tag = section + 100;
        [leftBtn setImage:[UIImage imageNamed:@"store_edit"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(editInfo:) forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:leftBtn];
    }

    return currentState;
}

-(void)doAdd
{
    AddDefectInfoViewController *vc = [[AddDefectInfoViewController alloc] init];
    vc.isAdd = YES;
    vc.myId = self.myId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editInfo:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataArr[index];

    AddDefectInfoViewController *vc = [[AddDefectInfoViewController alloc] init];
    vc.isAdd = NO;
    vc.myId = self.myId;
    vc.defectDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteInfo:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除此项?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteDetectInfo:index];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deleteDetectInfo:(NSInteger)index
{
    NSDictionary *dic = self.dataArr[index];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic[@"id"],@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestDeleteDefectInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self showToast:@"删除成功"];
            [weakSelf.dataArr removeObjectAtIndex:index];
            [weakSelf.myTableView reloadData];
        }else{
            [self showToast:@"删除失败"];
        }
    }];
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

//
//  AddUnqualityRecordViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "AddUnqualityRecordViewController.h"
#import "BaseTableView.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "Tools.h"

#import "BottomListShowView.h"
#import "EditRecordTableViewCell.h"

@interface AddUnqualityRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BaseTableView *myTableView;

@property (strong,nonatomic) UIButton *submitBtn;

@property (strong,nonatomic) BottomListShowView *listV;

@property (nonatomic,copy) NSString *dicReasonId;
@property (nonatomic,copy) NSString *dicSuggestId;


@end

@implementation AddUnqualityRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    [self.view addSubview:self.myTableView];
    
    if (!self.isAdd) {
        [self setInitData];
    }
}

-(void)setInitData
{
    NSInteger ReasonId = [self.recordDic[@"dicReasonId"] integerValue];
    for (NSDictionary *dic in self.reasonArr) {
        NSInteger reason = [dic[@"id"] integerValue];
        if (ReasonId == reason) {
            [self updateCell:dic type:YES];
            break;
        }
    }
    
    NSInteger suggestId = [self.recordDic[@"dicSuggestId"] integerValue];
    for (NSDictionary *dic in self.suggestArr) {
        NSInteger suggest = [dic[@"id"] integerValue];
        if (suggestId == suggest) {
            [self updateCell:dic type:NO];
            break;
        }
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditRecordTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    cell.numberTF.text = [NSString stringWithFormat:@"%@",self.recordDic[@"quantity"]];
}

-(void)setNavi
{
    if(self.isAdd)
    {
        self.title = @"添加不合格品处理记录";
    }else
    {
        self.title = @"修改不合格品处理记录";
    }
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
    
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(16, 20, SCREEN_WIDTH - 32, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SaveDefectInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
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
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
        [footerV addSubview:self.submitBtn];
        _myTableView.tableFooterView = footerV;
        
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EditRecordTableViewCell *cell  = [EditRecordTableViewCell cellWithTableView:tableView];
    [cell.reasonBtn addTarget:self action:@selector(ReasonClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.suggestBtn addTarget:self action:@selector(SuggestClick) forControlEvents:UIControlEventTouchUpInside];

    cell.numberTF.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 146.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = [NSString stringWithFormat:@"记录%ld",section+1];
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

    return currentState;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)ReasonClick
{
    [self showBottomListV:self.reasonArr type:YES];
}

-(void)SuggestClick
{
    [self showBottomListV:self.suggestArr type:NO];
}

-(void)showBottomListV:(NSArray *)dataArr type:(BOOL)isReason
{
    if (!self.listV) {
        self.listV = [[BottomListShowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.listV.showFrom = bottomAddUnqualityRecord;
    }
    WS(weakSelf)
    self.listV.StoreLocationBack = ^(NSDictionary * _Nullable dic) {
        [weakSelf updateCell:dic type:isReason];
    };
    self.listV.hidden = NO;
    self.listV.dataArr = dataArr;
    [self.view.window addSubview:self.listV];
}

-(void)updateCell:(NSDictionary *)dic type:(BOOL)isReason
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditRecordTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    if (isReason) {
        cell.reasonTF.text = [NSString stringWithFormat:@"%@",dic[@"dic_name"]];
        self.dicReasonId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }else
    {
        cell.suggestTF.text = [NSString stringWithFormat:@"%@",dic[@"dic_name"]];
        self.dicSuggestId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }
}

-(void)SaveDefectInfo
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditRecordTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    NSString *num = cell.numberTF.text;
    NSString *myid = @"0";
    if (!self.isAdd) {
        myid = self.recordDic[@"id"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.dicReasonId,@"dicReasonId",
                           self.dicSuggestId,@"dicSuggestId",
                           num,@"quantity",
                           self.rejectsBillId,@"rejectsBillId",
                           myid,@"id",
                           nil];
    WS(weakSelf)
    [UrlRequest requestSaveUnqualityReasonWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertVc addAction:action];
            [self presentViewController:alertVc animated:YES completion:nil];
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

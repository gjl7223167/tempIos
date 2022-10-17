//
//  UnqualityDetailViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityDetailViewController.h"
#import "BaseTableView.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "Tools.h"

#import "UnqualityBaseInfoTableViewCell.h"
#import "UnqualityRecordTableViewCell.h"

#import "AddUnqualityRecordViewController.h"

@interface UnqualityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *reasonArr;
@property (strong, nonatomic) NSMutableArray *suggestArr;

@property (strong,nonatomic) UIButton *submitBtn;

@end

@implementation UnqualityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    
    [self.view addSubview:self.myTableView];
    
    [self getReasonListData];
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return  _dataArr;
}

- (NSMutableArray *)reasonArr
{
    if (!_reasonArr) {
        _reasonArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _reasonArr;
}

- (NSMutableArray *)suggestArr
{
    if (!_suggestArr) {
        _suggestArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _suggestArr;
}

-(void)setNavi
{
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

    [self reloadState];

}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadState
{
    if (self.isDetail) {
        self.title = @"不合格品处理详情";
        
        self.myTableView.tableFooterView = [UIView new];
    }
    else{
        self.title = @"不合格品处理";
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        [footerV addSubview:self.submitBtn];
        self.myTableView.tableFooterView = footerV;
    }
    
    [self reloadRightBtnShow];
}

-(void)reloadRightBtnShow
{
    if (self.isDetail) {
        
        int status = [self.unqualityDic[@"status"] intValue];
        NSString *statusStr = [self getStatusCode:status];
        if ([statusStr isEqualToString:@"QOM_defective_product_disposal_03"]) {
            return;
        }
        //mes_unquality_handle 17*19    mes_black_delete  18*20
        
        UIButton  *rightButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton2 setImage:[UIImage imageNamed:@"mes_unquality_handle"] forState:UIControlStateNormal];
        [rightButton2 addTarget:self action:@selector(UnqualityHandleClick) forControlEvents:UIControlEventTouchUpInside];
        rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
        [rightButton2 setFrame:CGRectMake(0,0,40,40)];

        UIBarButtonItem * rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
        
        UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton1 setImage:[UIImage imageNamed:@"mes_black_delete"] forState:UIControlStateNormal];
        [rightButton1 addTarget:self action:@selector(UnqualityDeleteClick) forControlEvents:UIControlEventTouchUpInside];
        rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
        [rightButton1 setFrame:CGRectMake(0,0,40,40)];

        UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
        if ([statusStr isEqualToString:@"QOM_defective_product_disposal_02"]) {
            NSArray *actionButtonItems = @[rightBarButton2];
            self.navigationItem.rightBarButtonItems = actionButtonItems;
        }else if([statusStr isEqualToString:@"QOM_defective_product_disposal_01"])
        {
            NSArray *actionButtonItems = @[rightBarButton1,rightBarButton2];
            self.navigationItem.rightBarButtonItems = actionButtonItems;
        }
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
}


-(void)getReasonListData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.unqualityDic[@"id"],@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestUnqualityReasonListWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            NSArray *ReasonArr = data[@"data"];
            NSArray *SuggestArr = data[@"improve_suggestion"];
            NSArray *rejectsResonsArr = data[@"rejectsResons"];

            [weakSelf.dataArr addObjectsFromArray:rejectsResonsArr];
            [weakSelf.reasonArr addObjectsFromArray:ReasonArr];
            [weakSelf.suggestArr addObjectsFromArray:SuggestArr];
        }
        [self.myTableView reloadData];

    }];
}


- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(16, 20, SCREEN_WIDTH - 16 - 16, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"执行完毕" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
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
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return self.dataArr.count;
    }
    
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        UnqualityBaseInfoTableViewCell *cell = [UnqualityBaseInfoTableViewCell cellWithTableView:tableView];
        cell.dataDic = self.unqualityDic;
        return cell;
    }else if(indexPath.section == 2)
    {
        UnqualityRecordTableViewCell *cell = [UnqualityRecordTableViewCell cellWithTableView:tableView];
        cell.titleL.text = [NSString stringWithFormat:@"记录%ld",indexPath.row+1];
        if (self.isDetail) {
            cell.editBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }else{
            cell.editBtn.hidden = NO;
            cell.deleteBtn.hidden = NO;
            cell.editBtn.tag = indexPath.row + 100;
            cell.deleteBtn.tag = indexPath.row + 100;
            [cell.editBtn addTarget:self action:@selector(EditReason:) forControlEvents:UIControlEventTouchUpInside];
            [cell.deleteBtn addTarget:self action:@selector(DeleteReason:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSDictionary *dic = self.dataArr[indexPath.row];
        cell.numberL.text = [NSString stringWithFormat:@"%@",dic[@"quantity"]];
        cell.reasonL.text = [self ReasonName:dic];
        cell.suggestL.text = [self SuggestName:dic];
        
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 391.0;
        
    }else if (indexPath.section == 2)
    {
        return 195.0 + 10.0;
    }
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        NSString *imageN = @"";
        UIColor *color = [UIColor blackColor];
        int status = [self.unqualityDic[@"status"] intValue];
        NSString *statusStr = [self getStatusCode:status];

        if ([statusStr isEqualToString:@"QOM_defective_product_disposal_01"]) {
            imageN = @"daizx_i";
            color = [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1];
        }else if ([statusStr isEqualToString:@"QOM_defective_product_disposal_02"])
        {
            imageN = @"zhixz_i";
            color = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
        }else{
            imageN = @"yiwc_i";
            color = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1];
        }
        
        return [self gettopView:self.unqualityDic[@"statusName"] color:color image:imageN];
    }
    else if (section == 1)
    {
        return [self getHeaderV:@"基本信息" rightStr:nil rightSel:nil];
    }
    else if (section == 2)
    {
        if (self.isDetail) {
            return [self getHeaderV:@"不合格品处理记录" rightStr:nil rightSel:nil];
        }
        return [self getHeaderV:@"不合格品处理记录" rightStr:@"添加" rightSel:@"AddReason"];
    }
    else
    {
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 20)];
        headview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headview;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return  55.0f;
    }
    else if (section == 1)
    {
        return  55.0f;
    }
    else if (section == 2)
    {
        
        return  55.0f;
    }
    return  0.1f;
}

-(UIView *)gettopView:(NSString *)status color:(UIColor *)color image:(NSString *)imageN
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
    UIImageView *dotV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 15, 15)];
    dotV.image = [UIImage imageNamed:imageN];
    [bottomV addSubview:dotV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 80, 20)];
    label.text = @"当前状态：";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    UILabel *statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 80, 20)];
    statuslabel.text = status;
    statuslabel.font = [UIFont systemFontOfSize:14];
    
    statuslabel.textColor = color;
    [bottomV addSubview:statuslabel];
    
    return currentState;
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
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

-(NSString *)ReasonName:(NSDictionary *)rejectDic
{
    NSInteger ReasonId = [rejectDic[@"dicReasonId"] integerValue];
    for (NSDictionary *dic in self.reasonArr) {
        NSInteger reason = [dic[@"id"] integerValue];
        if (ReasonId == reason) {
            return [NSString stringWithFormat:@"%@",dic[@"dic_name"]];
        }
    }
    
    return @"";
}

-(NSString *)SuggestName:(NSDictionary *)rejectDic
{
    NSInteger suggestId = [rejectDic[@"dicSuggestId"] integerValue];
    for (NSDictionary *dic in self.suggestArr) {
        NSInteger suggest = [dic[@"id"] integerValue];
        if (suggestId == suggest) {
            return [NSString stringWithFormat:@"%@",dic[@"dic_name"]];
        }
    }
    
    return @"";
}

-(void)UnqualityHandleClick
{
    self.isDetail = NO;
    [self reloadState];
    [self.myTableView reloadData];
}

-(void)UnqualityDeleteClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该页面" message:@"删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteUnquality];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deleteUnquality
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.unqualityDic[@"id"],@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestDeleteUnqualityWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)AddReason
{
    NSLog(@"ddd");
    AddUnqualityRecordViewController *vc = [[AddUnqualityRecordViewController alloc] init];
    vc.rejectsBillId = [NSString stringWithFormat:@"%@",self.unqualityDic[@"id"]];
    vc.isAdd = YES;
    vc.reasonArr = self.reasonArr;
    vc.suggestArr = self.suggestArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)EditReason:(UIButton *)sender
{
    AddUnqualityRecordViewController *vc = [[AddUnqualityRecordViewController alloc] init];
    vc.rejectsBillId = [NSString stringWithFormat:@"%@",self.unqualityDic[@"id"]];
    vc.isAdd = NO;
    vc.reasonArr = self.reasonArr;
    vc.suggestArr = self.suggestArr;
    vc.recordDic = self.dataArr[sender.tag - 100];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)DeleteReason:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该记录" message:@"删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteReasonRecord:index];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)deleteReasonRecord:(NSInteger)index
{
    NSDictionary *dic = self.dataArr[index];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic[@"id"],@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestDeleteUnqualityReasonWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.dataArr removeObjectAtIndex:index];
            [weakSelf.myTableView reloadData];
        }
    }];
}

-(void)SubmitClick
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.unqualityDic[@"id"],@"id",
                            @"1",@"flag",
                            nil];
    WS(weakSelf)
    [UrlRequest requestUnqualityHandleEndWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}


-(NSString *)getStatusCode:(int)status
{
    NSString *dic_code = @"";
    for (NSDictionary *dic in self.titleArr) {
        NSInteger sts = [dic[@"id"] intValue];
        if (status == sts) {
            dic_code = dic[@"dic_code"];
        }
    }
    
    return dic_code;
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

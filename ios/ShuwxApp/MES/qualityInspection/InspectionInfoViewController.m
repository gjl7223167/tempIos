//
//  InspectionInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InspectionInfoViewController.h"
#import "BaseTableView.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "Tools.h"

#import "workStyleOneTableViewCell.h"
#import "InspectionInfoTableViewCell.h"


@interface InspectionInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSArray *showItems;
@property (strong, nonatomic) NSArray *keys;

@property (strong,nonatomic) UIButton *submitBtn;

@property (strong,nonatomic) UITextField *currentTF;

@end

@implementation InspectionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    self.showItems = [NSArray arrayWithObjects:@"检验项",@"结果类型",@"检验单位",@"上限值",@"下限值",@"标准值",@"检验平均值",@"检验最大值",@"检验最小值",@"检验合格数",@"检验不合格数", nil];
    self.keys = [NSArray arrayWithObjects:@"name",@"typeName",@"unitsName",@"highValue",@"lowValue",@"standardValue",@"averageValue",@"maxValue",@"minValue",@"qualifiedQty",@"unqualifiedQty", nil];
    [self.view addSubview:self.myTableView];
    
    [self getInspectionInfoData];
}


-(void)setNavi
{
    self.title = @"检验项信息";
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
    [UrlRequest requestInspectionItemInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            [self.dataArr addObjectsFromArray:data];
        }
        [self.myTableView reloadData];

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
        
        if (!self.isDetail) {
            UIView *footerV = [[UIView alloc] init];
            footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
            footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
            [footerV addSubview:self.submitBtn];
            _myTableView.tableFooterView = footerV;
        }
        
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return self.dataArr.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.showItems.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.section];
    NSString *title = self.showItems[indexPath.row];
    NSString *key = self.keys[indexPath.row];

    if (indexPath.row > 5) {
        InspectionInfoTableViewCell *cell = [InspectionInfoTableViewCell cellWithTableView:tableView];
        cell.leftTitleL.text = title;
        if (self.isDetail) {
            cell.rightTF.hidden = YES;
            cell.rightL.text = [Tools getEmptyString:dic[key]];
        }else
        {
            cell.rightL.hidden = YES;
            cell.rightTF.text = [Tools getEmptyString:dic[key]];
            cell.rightTF.delegate = self;
            cell.indexPath = indexPath;
        }

        return cell;
    }
    
    workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
    cell.leftLabel.text = title;
    cell.rightLabel.text = [Tools getEmptyString:dic[key]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 49.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = [NSString stringWithFormat:@"信息%ld",section+1];
    return [self getHeaderV:title rightStr:nil rightSel:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  55.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.currentTF resignFirstResponder];
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    InspectionInfoTableViewCell *cell = (InspectionInfoTableViewCell *)textField.superview.superview.superview;
    NSString *value = cell.rightTF.text;
    NSString *key = self.keys[cell.indexPath.row];
    
    NSDictionary *dic = self.dataArr[cell.indexPath.section];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [muDic setValue:value forKey:key];
    [self.dataArr replaceObjectAtIndex:cell.indexPath.section withObject:muDic];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTF = textField;
    return YES;
}


-(void)ModifyInspectionInfo
{
    NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:self.dataArr.count];
    for (NSDictionary *dic in self.dataArr) {
        NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
        [mudic setValue:[Tools getEmptyString:dic[@"averageValue"]] forKey:@"averageValue"];
        [mudic setValue:[Tools getEmptyString:dic[@"id"]] forKey:@"id"];
        [mudic setValue:[Tools getEmptyString:dic[@"maxValue"]] forKey:@"maxValue"];
        [mudic setValue:[Tools getEmptyString:dic[@"minValue"]] forKey:@"minValue"];
        [mudic setValue:[Tools getEmptyString:dic[@"qualifiedQty"]] forKey:@"qualifiedQty"];
        [mudic setValue:[Tools getEmptyString:dic[@"qualityInspectionPlanId"]] forKey:@"qualityInspectionPlanId"];
        [mudic setValue:[Tools getEmptyString:dic[@"schemeSubjectRelaId"]] forKey:@"schemeSubjectRelaId"];
        [mudic setValue:[Tools getEmptyString:dic[@"unqualifiedQty"]] forKey:@"unqualifiedQty"];

        [newArr addObject:mudic];
    }
    
    WS(weakSelf)
    [UrlRequest requestModifyInspectionInfoWithParam:newArr completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
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

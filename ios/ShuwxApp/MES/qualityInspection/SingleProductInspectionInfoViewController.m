//
//  SingleProductInspectionInfoViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "SingleProductInspectionInfoViewController.h"
#import "BaseTableView.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "Tools.h"

#import "SingleProductTableViewCell.h"

@interface SingleProductInspectionInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;


@property (strong,nonatomic) UIButton *submitBtn;

@end

@implementation SingleProductInspectionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];

    [self.view addSubview:self.myTableView];
    
    [self getSingleProductInfoData];
}

-(void)setNavi
{
    self.title = @"单件产品检验信息";
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
        [_submitBtn addTarget:self action:@selector(SaveSingleProductInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)getSingleProductInfoData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.myId,@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestSingleProductInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
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

    return self.dataArr.count + 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return 1;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.section - 1];
    SingleProductTableViewCell *cell = [SingleProductTableViewCell cellWithTableView:tableView];
    cell.serialNumL.text = [Tools getEmptyString:dic[@"ic"]];
    [cell.chooseBtn addTarget:self action:@selector(ChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.chooseBtn.tag = 100 + indexPath.section;
    
    NSInteger isQualified = [dic[@"isQualified"] integerValue];
    if (1 == isQualified) {
        //合格
        cell.chooseTF.text = @"合格";
    }else if (2 == isQualified)
    {
        //待检验
        cell.chooseTF.text = @"待检验";
    }else if(0 == isQualified){
        //不合格
        cell.chooseTF.text = @"不合格";
    }else{
        cell.chooseTF.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDetail) {
        return 48.0f;
    }
    return 97.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self gettopView:self.dataArr.count];
    }
    NSDictionary *dic = self.dataArr[section - 1];

    NSString *title = [NSString stringWithFormat:@"%@",[Tools getEmptyString:dic[@"materialName"]]];
    NSInteger isQualified = 100;
    if (self.isDetail) {
         isQualified = [dic[@"isQualified"] integerValue];
    }
    return [self getHeaderV:title isQualified:isQualified];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  55.0f;
}


-(UIView *)gettopView:(NSInteger)number
{
    UIView *currentState = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    
    currentState.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [currentState addSubview:bottomV];
    
    UIImageView *dotV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 15, 15)];
    dotV.image = [UIImage imageNamed:@"zhixz_i"];
    [bottomV addSubview:dotV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 20)];
    label.text = [NSString stringWithFormat:@"共计%ld件产品",number];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [bottomV addSubview:label];
    
    return currentState;
}

-(UIView *)getHeaderV:(NSString *)leftStr isQualified:(NSInteger)isQualified
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
    
    if (self.isDetail) {
        NSString *imgName = @"";
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(SCREEN_WIDTH - 16 - 37, 12, 37, 15);

        if (1 == isQualified) {
            //合格
            imgV.frame = CGRectMake(SCREEN_WIDTH - 16 - 26, 12, 26, 15);
            imgName = @"mes_heg";

        }else if (2 == isQualified)
        {
            //待检验
            imgName = @"mes_daijy";

        }else if(0 == isQualified){
            //不合格
            imgName = @"mes_buhg";

        }else{
            
        }
        
        imgV.image = [UIImage imageNamed:imgName];
        [bottomV addSubview:imgV];
    }
    
    return currentState;
}

-(void)ChooseClick:(UIButton *)sender
{
    NSInteger section = sender.tag - 100;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:section];
    SingleProductTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"合格" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cell.chooseTF.text = @"合格";
        [self modifyArr:section - 1 data:@"1"];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不合格" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.chooseTF.text = @"不合格";
        [self modifyArr:section - 1 data:@"0"];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"待检验" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.chooseTF.text = @"待检验";
        [self modifyArr:section - 1 data:@"2"];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)modifyArr:(NSInteger)index data:(NSString *)value
{
    NSDictionary *dic = self.dataArr[index];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mudic setValue:value forKey:@"isQualified"];
    [self.dataArr replaceObjectAtIndex:index withObject:mudic];
}

-(void)SaveSingleProductInfo
{
    NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:self.dataArr.count];
    for (NSDictionary *dic in self.dataArr) {
        NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
        [mudic setValue:[Tools getEmptyString:dic[@"id"]] forKey:@"id"];
        [mudic setValue:[Tools getEmptyString:dic[@"isQualified"]] forKey:@"isQualified"];
        
        [newArr addObject:mudic];
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
    newArr,@"list",
    nil];
    WS(weakSelf)
    [UrlRequest requestSaveSingleInspectionInfoWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
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

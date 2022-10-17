//
//  QualityRecordModelViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/16.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "QualityRecordModelViewController.h"
#import "BaseTableView.h"
#import "workStyleOneTableViewCell.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "UrlRequestModel.h"
#import "NSObject+modelValue.h"
#import "RemarksView.h"

#import "ArrowIndicatorTableViewCell.h"
#import "InspectionResultTableViewCell.h"

#import "Tools.h"

#import "QualityStandardViewController.h"
#import "InspectionInfoViewController.h"
#import "SingleProductInspectionInfoViewController.h"
#import "DefectInfoViewController.h"

@interface QualityRecordModelViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger modelCount;
    BOOL arrowDown;
    BOOL isSequencer;
}
@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) dispatch_semaphore_t sema;

@property (strong,nonatomic) RemarksView *remarksV;
@property (strong,nonatomic) UIButton *submitBtn;
@property (nonatomic,copy)NSString *markStr;
@property (strong,nonatomic) UIButton *saveBtn;

@property (strong,nonatomic) NSDictionary *ModelDetailDic;
@property (strong,nonatomic) NSDictionary *baseDetailDic;



@end

@implementation QualityRecordModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.isDetail = YES;
    arrowDown = YES;
    modelCount = 4;
    isSequencer = NO;
    [self setNavi];
    
    [self.view addSubview:self.myTableView];
    
    [self requestModelDetailData];
    
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
        self.title = @"质检计划详情";
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 132);
        
        [footerV addSubview:self.remarksV];
        self.remarksV.contentTV.editable = NO;
        self.myTableView.tableFooterView = footerV;
    }
    else{
        self.title = @"质检记录";
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [footerV addSubview:self.remarksV];
        [footerV addSubview:self.submitBtn];
        [footerV addSubview:self.saveBtn];
        self.remarksV.contentTV.editable = YES;
        self.myTableView.tableFooterView = footerV;
    }
    
}

-(void)reloadRightBtnShow
{
    if (self.isDetail) {
        
        int status = [self.baseDetailDic[@"status"] intValue];
        NSString *statusStr = [self getStatusCode:status];
        if ([statusStr isEqualToString:@"QOM_Inspection_status_04"]) {
            return;
        }
        NSString *title = @"检验记录";
        if ([statusStr isEqualToString:@"QOM_Inspection_status_03"]) {
            title = @"不合格产品处理";
        }
        UIButton  *rightButton1  = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton1 setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
        [rightButton1  setTitle:title forState:UIControlStateNormal];
        [rightButton1 addTarget:self action:@selector(InsectionRecord) forControlEvents:UIControlEventTouchUpInside];
        rightButton1.titleLabel.font = [UIFont systemFontOfSize:14];
        rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [rightButton1 setFrame:CGRectMake(0,0,40,40)];
        UIBarButtonItem * rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
        
        NSArray *actionButtonItems = @[rightBarButton1];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
}

-(void)InsectionRecord
{
    int status = [self.baseDetailDic[@"status"] intValue];
    NSString *statusStr = [self getStatusCode:status];

    if ([statusStr isEqualToString:@"QOM_Inspection_status_03"]) {
        
    }else{
        self.isDetail = NO;
        [self reloadState];
        [self reloadRightBtnShow];
        [self.myTableView reloadData];
    }
}

-(void)requestModelDetailData
{
    dispatch_queue_t customQ = dispatch_queue_create("dddd", DISPATCH_QUEUE_CONCURRENT);
    self.sema = dispatch_semaphore_create(0);
    dispatch_async(customQ, ^{
        [self getDetailModelData];
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        [self getDetailData];
    });
}

-(void)getDetailModelData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.myId,@"id",
                            @"qualityInspection",@"code",
                            nil];
    WS(weakSelf)
    [UrlRequestModel requestDetailModelWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            if (![data isKindOfClass:[NSNull class]]) {
                NSDictionary *dataD = [NSDictionary dictionaryWithDictionary:data];
                NSArray *dataArr = [NSArray arrayWithObject:dataD];
                
                dataArr = [weakSelf.propertyArr ModelArrayFromrecords:dataArr propertyInfo:nil];
                weakSelf.ModelDetailDic = [NSDictionary dictionaryWithDictionary:dataArr[0]];
            }
            
            dispatch_semaphore_signal(weakSelf.sema);
        }
    }];
}

-(void)getDetailData
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.myId,@"id",
                            nil];
    WS(weakSelf)
    [UrlRequest requestQualityRecordWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            weakSelf.baseDetailDic = [NSDictionary dictionaryWithDictionary:data];
            weakSelf.markStr = [Tools getString:weakSelf.baseDetailDic[@"remark"]];
            weakSelf.remarksV.contentTV.text = weakSelf.markStr;
            weakSelf.remarksV.contentTV.placeholder = @"";
            NSInteger uid = [weakSelf.baseDetailDic[@"recordType"] integerValue];
            if (uid == 824) {
                self->isSequencer = YES;
            }
            [weakSelf reloadRightBtnShow];
        }
        [self.myTableView reloadData];

    }];
}

-(void)getOtherNeedData
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"BASE_controlType",@"dic_type",
                            nil];
    WS(weakSelf)
    [UrlRequest requestSelectDictionaryByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
            if (dataArr.count > 0) {
                NSInteger uid = [weakSelf.baseDetailDic[@"recordType"] integerValue];
                NSDictionary *dic = nil;
                for (NSDictionary *diction in dataArr) {
                    if (uid == [diction[@"id"] integerValue]) {
                        dic = diction;
                    }
                }
                
                if (dic) {
                    if (dic[@"dic_name"]&&[@"序列件" isEqualToString:dic[@"dic_name"]]) {
                        self->isSequencer = YES;
                    }
                }
            }
        }
        
        [self.myTableView reloadData];

    }];
}


- (RemarksView *)remarksV
{
    if (!_remarksV) {
        _remarksV = [[RemarksView alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 100)];
        WS(weakSelf)
        _remarksV.contentTV.infoBlock = ^(NSString *text, CGSize textViewSize) {
//            NSLog(@"当前文字: %@   当前高度:%lf",text,textViewSize.height);
            weakSelf.markStr = text;
        };
    }
    return _remarksV;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(SCREEN_WIDTH/2.0 + 10, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, SCREEN_WIDTH/2.0 - 10 -16, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"检验完成" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(16, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, SCREEN_WIDTH/2.0 - 10 - 16, 50);
        [_saveBtn setBackgroundColor:[UIColor whiteColor]];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
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

    if (self.baseDetailDic) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        if (self.ModelDetailDic) {
            return 1 + modelCount;
        }
        return 0;
    }
    else if (section == 2)
    {
        if (self.baseDetailDic) {
            return 1;
        }
        return 0;
    }
    
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        InspectionResultTableViewCell *cell = [InspectionResultTableViewCell cellWithTableView:tableView];
        cell.dataDic = self.baseDetailDic;

        if (self.isDetail) {
            cell.canEditable = NO;
        }else{
            cell.canEditable = YES;
        }
        
        return cell;
        
    }
    if (indexPath.section == 1) {

        if (indexPath.row == modelCount) {
            ArrowIndicatorTableViewCell *cell = [ArrowIndicatorTableViewCell cellWithTableView:tableView];
            if (arrowDown) {
                cell.arrowImgV.highlighted = NO;
            }else{
                cell.arrowImgV.highlighted = YES;
            }
            return cell;
        }
    }
    workStyleOneTableViewCell *cell = [workStyleOneTableViewCell cellWithTableView:tableView];
    cell.propertyM = self.propertyArr[indexPath.row];
    cell.valueDic = self.ModelDetailDic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 245.0;
    }
    
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((1 == indexPath.section)&&(modelCount == indexPath.row)) {
        arrowDown = !arrowDown;
        if (arrowDown) {
            modelCount = 4;
        }else{
            modelCount = self.propertyArr.count;
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
    if (section == 0) {
        NSString *imageN = @"";
        UIColor *color = [UIColor blackColor];
        int status = [self.baseDetailDic[@"status"] intValue];
        NSString *statusStr = [self getStatusCode:status];

        if ([statusStr isEqualToString:@"QOM_Inspection_status_01"]) {
            imageN = @"daizx_i";
            color = [UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:0.0/255.0 alpha:1];
        }else if([statusStr isEqualToString:@"QOM_Inspection_status_02"])
        {
            imageN = @"zhixz_i";
            color = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
        }else if([statusStr isEqualToString:@"QOM_Inspection_status_03"])
        {
            imageN = @"yiwc_i";
            color = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:120.0/255.0 alpha:1];
        }else{
            imageN = @"zant_i";
            color = [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:16.0/255.0 alpha:1];
        }
        
        return [self gettopView:self.baseDetailDic[@"statusName"] color:color image:imageN];
    }
    else if (section == 1)
    {
        return [self getHeaderV:@"检验计划基本信息" rightStr:@"检验标准" rightSel:@"InspectionStandard"];
    }
    else if (section == 2)
    {
        return [self getHeaderV:@"检验结果记录" rightStr:@"检验信息" rightSel:@"InspectionInfo"];
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
        if (isSequencer) {
            return 110.0f;
        }
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
    
    if ([@"检验结果记录" isEqualToString:leftStr]&&isSequencer) {
        currentState.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        UIView *signleView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 55)];
        signleView.backgroundColor = [UIColor whiteColor];
        [currentState addSubview:signleView];
        
        NSInteger number = [self.baseDetailDic[@"inspectionQty"] integerValue];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 200, 21)];
        label.text = [NSString stringWithFormat:@"共计%ld件产品",number];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        [signleView addSubview:label];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"单件产品检验信息" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(signleView.frame.size.width - 110 - 16, 12, 110, 31);
        [rightBtn addTarget:self action:@selector(SignleProductInfo) forControlEvents:UIControlEventTouchUpInside];
        [signleView addSubview:rightBtn];
    }
    
    return currentState;
}

-(void)InspectionStandard
{
    QualityStandardViewController *vc = [[QualityStandardViewController alloc] init];
    vc.myId = self.myId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)InspectionInfo
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"检验项信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        InspectionInfoViewController *vc = [[InspectionInfoViewController alloc] init];
        vc.myId = self.myId;
        vc.isDetail = self.isDetail;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"缺陷信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DefectInfoViewController *vc = [[DefectInfoViewController alloc] init];
        vc.myId = self.myId;
        vc.isDetail = self.isDetail;
        [self.navigationController pushViewController:vc animated:YES];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:action1];
    [alertC addAction:action2];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}

-(void)SignleProductInfo
{
    SingleProductInspectionInfoViewController *vc = [[SingleProductInspectionInfoViewController alloc] init];
    vc.myId = self.myId;
    vc.isDetail = self.isDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SubmitClick
{
    [self UpLoadData:@"2"];
}

-(void)SaveClick
{
    [self UpLoadData:@"1"];
}

-(void)UpLoadData:(NSString *)flag
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
    InspectionResultTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    if (cell.qualifiedNumTF.text.length == 0) {
        [self showToast:@"请填写合格数量"];
        return;
    }
    if (cell.unqualifiedNumTF.text.length == 0) {
        [self showToast:@"请填写不合格数量"];
        return;
    }
    if (cell.inspectionNumTF.text.length == 0) {
        [self showToast:@"请填写实检数量"];
        return;
    }
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.myId,@"id",
                            flag,@"flag",//1\2
                            cell.qualifiedNumTF.text,@"qualifiedQty",
                            cell.unqualifiedNumTF.text,@"unqualifiedQty",
                            cell.inspectionNumTF.text,@"realInspectionQty",
                            self.markStr,@"remark",
                            nil];
    WS(weakSelf)
    [UrlRequest requestQualityInspectionSaveWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
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

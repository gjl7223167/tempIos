//
//  UnqualityHandleViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/22.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityHandleViewController.h"
#import "WRNavigationBar.h"
#import "BaseTableView.h"
#import "UrlRequest.h"

#import "RemarksView.h"
#import "UnqualityHandleTableViewCell.h"

@interface UnqualityHandleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong,nonatomic) RemarksView *remarksV;
@property (strong,nonatomic) UIButton *submitBtn;

@property (nonatomic,copy) NSString *markStr;

@end

@implementation UnqualityHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    [self.view addSubview:self.myTableView];
}


-(void)setNavi
{
    self.title = @"创建不合格品处理单";

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

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArr;
}


- (RemarksView *)remarksV
{
    if (!_remarksV) {
        _remarksV = [[RemarksView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//        _remarksV.backgroundColor = [UIColor redColor];
        self.markStr = @"";
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
        _submitBtn.frame = CGRectMake(16, self.remarksV.frame.origin.y + self.remarksV.frame.size.height + 20, SCREEN_WIDTH - 32, 50);
        [_submitBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - kBottomSafeAreaHeight) style:UITableViewStyleGrouped];
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.alwaysBounceVertical = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [footerV addSubview:self.remarksV];
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
    
    UnqualityHandleTableViewCell *cell = [UnqualityHandleTableViewCell cellWithTableView:tableView];
    cell.dataDic = self.dataDic;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 294.0f;
}

-(void)SubmitClick
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    UnqualityHandleTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
    if(cell.NumberTF.text.length == 0)
    {
        [self showToast:@"请填写数量"];
        return;
    }
    NSString *number = cell.NumberTF.text;
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.dataDic[@"code"],@"code",
                            self.dataDic[@"id"],@"qualityInspectionPlanId",
                            @"1",@"flag",//保存 2   处理完成 1
                            number,@"quantity",
                            self.markStr,@"remark",
                            nil];
    WS(weakSelf)
    [UrlRequest requestUnqualityHandleCreateWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
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

-(NSString *)getStringWith:(id)Str
{
    if ([Str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",Str];
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

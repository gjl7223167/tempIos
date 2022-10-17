//
//  workCreateViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/17.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "workCreateViewController.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"
#import "XuDatePickManager.h"
#import "OperatorListViewController.h"
#import "WorkOperatorModel.h"

@interface workCreateViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productNameL;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UILabel *operatorL;
@property (weak, nonatomic) IBOutlet UILabel *realStartTimeL;
@property (weak, nonatomic) IBOutlet UILabel *realFinishTimeL;

@property (nonatomic ,strong) NSString *operator;
@property (nonatomic ,strong) NSString *realStartT;
@property (nonatomic ,strong) NSString *realFinishT;

@property (nonatomic ,assign) NSInteger startOrEnd;

@property (nonatomic ,strong) NSArray *selectedOperatorArr;

@end

@implementation workCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    
    self.operator = @"";
    self.realStartT = @"";
    self.realFinishT = @"";
    self.numberTF.delegate = self;
    self.productNameL.text = self.productName;
    
    
}
-(void)setNavi
{
    self.title = @"创建报工信息";
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn==%@",textField.text);
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)numEndEdit:(id)sender {
    NSLog(@"numEndEdit==");

}

- (IBAction)OperatorChoose:(id)sender {
    OperatorListViewController *vc = [[OperatorListViewController alloc] init];
    vc.selectedOperatorArr = self.selectedOperatorArr;
    vc.OperatorB = ^(NSArray * _Nonnull operatorArr) {
        self.selectedOperatorArr = [NSArray arrayWithArray:operatorArr];
        
        NSMutableArray *operator = [[NSMutableArray alloc] init];
        for (WorkOperatorModel *model in operatorArr) {
            [operator addObject:model.name];
        }
        self.operator = [operator componentsJoinedByString:@"、"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)StartTimeChoose:(id)sender {
    self.startOrEnd = 1;
    [self ChooseDate];
}

- (IBAction)FinishTimeChoose:(id)sender {
    self.startOrEnd = 2;
    [self ChooseDate];
}

- (void)setOperator:(NSString *)operator
{
    if (operator.length == 0) {
        self.operatorL.text = @"请选择";
    }
    else
    {
        self.operatorL.text = operator;
    }
    _operator = operator;
}

- (void)setRealStartT:(NSString *)realStartT
{
    if (realStartT.length == 0) {
        self.realStartTimeL.text = @"请选择";
    }
    else
    {
        self.realStartTimeL.text = realStartT;
    }
    _realStartT = realStartT;
}

- (void)setRealFinishT:(NSString *)realFinishT
{
    if (realFinishT.length == 0) {
           self.realFinishTimeL.text = @"请选择";
       }
       else
       {
           self.realFinishTimeL.text = realFinishT;
       }
    _realFinishT = realFinishT;
}



- (IBAction)SaveInfo:(id)sender {
    
    [self.numberTF resignFirstResponder];
    
    if ([self.numberTF.text integerValue] < 1) {
        return;
    }
    if (self.realStartT.length < 1) {
        return;
    }
    if (self.realFinishT.length < 1) {
        return;
    }
    if (self.operator.length < 1) {
        return;
    }
    
    NSLog(@"SaveInfo");
    
    [self saveWorkInfo];
}

-(void)saveWorkInfo
{
    NSMutableArray *operator = [[NSMutableArray alloc] init];
    for (WorkOperatorModel *model in self.selectedOperatorArr) {
        [operator addObject:model.name];
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"workOrderId",
                            self.realStartT,@"startTime",
                            self.realFinishT,@"endTime",
                            self.productName,@"materialName",
                            self.numberTF.text,@"qty",
                            operator,@"reportUser",
                            nil];
    WS(weakSelf)
    [UrlRequest requestWorkCreateWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}


-(void)ChooseDate
{
    XuDatePickManager *datePickManager = [[XuDatePickManager alloc] init];
    datePickManager.DatePickerB = ^(NSString * _Nonnull dateStr) {
        if (self.startOrEnd == 1) {
            self.realStartT = dateStr;
        }
        else
        {
            self.realFinishT = dateStr;
        }
    };
    [self presentViewController:datePickManager animated:NO completion:nil];
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

//
//  materialCreateViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/17.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "materialCreateViewController.h"
#import "WRNavigationBar.h"
#import "UrlRequest.h"

#import "SearchViewController.h"

@interface materialCreateViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *materialNameL;

@property (weak, nonatomic) IBOutlet UITextField *BatchNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *SerialNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *NumberTF;

@property (nonatomic ,strong) NSString *materialName;
@property (nonatomic ,strong) NSString *materialId;


@end

@implementation materialCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    
    self.materialName = @"";
    self.BatchNumberTF.delegate = self;
    self.SerialNumberTF.delegate = self;
    self.NumberTF.delegate = self;
        
    if (self.materialDic) {
        [self setMaterial:self.materialDic];
    }
}
-(void)setNavi
{
    self.title = @"创建上料信息";
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setMaterialName:(NSString *)materialName
{
    if (materialName&&materialName.length != 0) {
        self.materialNameL.text = materialName;
        _materialName = materialName;
    }
    else
    {
        self.materialNameL.text = @"请选择";
        _materialName = nil;
    }
    
}

- (IBAction)MaterialChoose:(id)sender {
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchFrom = searchMaterialCreate;
    vc.paramDic = @{@"workOrderId":self.workOrderId};
    vc.SearchBackB = ^(NSDictionary * _Nullable dic) {
        if (dic) {
            [self setMaterial:dic];
        }
    };
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)setMaterial:(NSDictionary *)dic
{
    self.materialName = [NSString stringWithFormat:@"%@",dic[@"materialName"]];
    self.materialId = [NSString stringWithFormat:@"%@",dic[@"materialId"]];
}

- (IBAction)SaveInfo:(id)sender {
    [self.BatchNumberTF resignFirstResponder];
    [self.SerialNumberTF resignFirstResponder];
    [self.NumberTF resignFirstResponder];
    
    
    if (self.materialName.length == 0) {
        return;
    }
    if (self.BatchNumberTF.text.length == 0) {
        return;
    }
    if (self.SerialNumberTF.text.length == 0) {
        return;
    }
    if (self.NumberTF.text.length == 0) {
        return;
    }
    
    [self saveMaterialInfo];
}

-(void)saveMaterialInfo
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.workOrderId,@"workOrderId",
                            self.BatchNumberTF.text,@"batchCode",
                            self.materialId,@"materialId",
                            self.materialName,@"materialName",
                            self.NumberTF.text,@"qty",
                            self.SerialNumberTF.text,@"sequenceCode",
                            nil];
    WS(weakSelf)
    [UrlRequest requestMaterialCreateWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
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

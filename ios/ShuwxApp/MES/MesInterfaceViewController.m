//
//  MesInterfaceViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/26.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "MesInterfaceViewController.h"
#import "WRNavigationBar.h"

#import "WorkingProcedureMainViewController.h"
#import "RequirementOfInOutStoreroomViewController.h"
#import "StoreRoomManagerViewController.h"
#import "QualityInspectionPlanManageViewController.h"
#import "UnqualityHandleMainViewController.h"

@interface MesInterfaceViewController ()

@end

@implementation MesInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
}


-(void)setNavi
{
    self.navigationItem.title = @"菜单";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gerengongzuotai:(id)sender {
    WorkingProcedureMainViewController *vc = [[WorkingProcedureMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)wuliao:(id)sender {
    RequirementOfInOutStoreroomViewController *vc = [[RequirementOfInOutStoreroomViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)chukuruku:(id)sender {
    StoreRoomManagerViewController *vc = [[StoreRoomManagerViewController alloc] init];
    vc.isInStoreRoom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chuKuClick:(id)sender {
    StoreRoomManagerViewController *vc = [[StoreRoomManagerViewController alloc] init];
    vc.isInStoreRoom = NO;
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)zhijian:(id)sender {
    QualityInspectionPlanManageViewController *vc = [[QualityInspectionPlanManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)buhegepin:(id)sender {
    UnqualityHandleMainViewController *vc = [[UnqualityHandleMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

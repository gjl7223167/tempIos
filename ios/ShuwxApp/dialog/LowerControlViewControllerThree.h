//
//  LowerControlViewControllerThree.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/22.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
typedef void (^ReturnValueBlock) (NSString *strValue);
@interface LowerControlViewControllerThree : MainViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIView *xiakView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *xiakValue;
@property (nonatomic, strong) NSString * deviceName;
@property (weak, nonatomic) IBOutlet UILabel *dataMonitorName;


@end

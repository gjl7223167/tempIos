//
//  LowerControlViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/21.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"

typedef void (^ReturnValueBlock) (NSString *strValue);

@interface LowerControlViewController : MainViewController{
@public int dataType ; // 下控类型  0  分    1  合
}
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (weak, nonatomic) IBOutlet UIView *viewbg;
@property (weak, nonatomic) IBOutlet UIView *xiakView;

@property (nonatomic, strong) UIButton * sinaButton;
@property (nonatomic, strong) UIButton * bankButton;

@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic, strong) NSString * deviceName;
@property (weak, nonatomic) IBOutlet UILabel *dataMonitorName;

@end


//
//  LowerControlViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/21.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "LowerControlViewController.h"

@interface LowerControlViewController ()

@end

@implementation LowerControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewbg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.dataMonitorName.text = _deviceName;
    //设置圆角半径值
    self.xiakView.layer.cornerRadius  = 10.f;
    //设置为遮罩，除非view有阴影，否则都要指定为YES的
    self.xiakView.layer.masksToBounds = YES;
    
      [self.cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.okBtn addTarget:self action:@selector(setOkBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.sinaButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _sinaButton.frame = CGRectMake(100, 70, 30, 30);
    [_sinaButton setBackgroundImage:[UIImage imageNamed:@"invest_delecte"] forState:(UIControlStateNormal)];
    [_sinaButton setBackgroundImage:[UIImage imageNamed:@"invest_selecte"] forState:(UIControlStateSelected)];
    [_sinaButton addTarget:self action:@selector(sinaAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.xiakView addSubview:_sinaButton];
    
    
    UIButton *sinaNme = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sinaNme.frame = CGRectMake(130, 75, 25, 25);
    sinaNme.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [sinaNme setTitle:@"分"  forState:(UIControlStateNormal)];
    [sinaNme setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [sinaNme addTarget:self action:@selector(sinaAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.xiakView addSubview:sinaNme];
    
    
    
    self.bankButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _bankButton.frame = CGRectMake(160, 70, 30, 30);
    [_bankButton setBackgroundImage:[UIImage imageNamed:@"invest_delecte"] forState:(UIControlStateNormal)];
    [_bankButton setBackgroundImage:[UIImage imageNamed:@"invest_selecte"] forState:(UIControlStateSelected)];
    [_bankButton addTarget:self action:@selector(bankAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.xiakView addSubview:_bankButton];

    UIButton *banknameSelete = [UIButton buttonWithType:(UIButtonTypeCustom)];
    banknameSelete.frame = CGRectMake(190, 75, 25, 25);
    [banknameSelete setTitle:@"合" forState:(UIControlStateNormal)];
    [banknameSelete setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [banknameSelete addTarget:self action:@selector(bankAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.xiakView addSubview:banknameSelete];
    
    // 先默认一个选项
    _sinaButton.selected = YES;
    
    dataType = 0; // 下控类型  0  分    1  合
    
    //得到view的遮罩路径
    UIBezierPath *maskPathggg = [UIBezierPath bezierPathWithRoundedRect:self.btnView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(0,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.btnView.bounds;
    //赋值
    maskLayer.path = maskPathggg.CGPath;
    self.btnView.layer.mask = maskLayer;
    
    //得到view的遮罩路径
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.cancelBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,0)];
    //创建 layer
    CAShapeLayer *maskLayeree = [[CAShapeLayer alloc] init];
    maskLayeree.frame = self.cancelBtn.bounds;
    //赋值
    maskLayeree.path = maskPath1.CGPath;
    self.cancelBtn.layer.mask = maskLayeree;
  
    
    self.xiakView.userInteractionEnabled=YES;
      UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
     [self.xiakView addGestureRecognizer:ggggg];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
    
    [self.view addGestureRecognizer:gesture];
    
    
}
-(void)setCancelBtn{
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}
-(void)setOkBtn{
    
    NSString *dataTypeStr = [NSString stringWithFormat:@"%d", dataType];
    
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(dataTypeStr);
    }
    [self tagGesture1];
}

-(void)tagGesture1 {
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
    
}
-(void)tagGesture2 {
    
}

- (void)sinaAction:(UIButton *)button
{
    if (_sinaButton.selected) {
        
    }
    else if (!_sinaButton.selected)
    {
        _sinaButton.selected = YES;
        _bankButton.selected = NO;
    }
   // NSLog(@"支付宝");
    dataType = 0;
}

- (void)bankAction:(UIButton *)button
{
    
    if (_bankButton.selected) {
        
    }
    else if (!_bankButton.selected)
    {
        _bankButton.selected = YES;
        _sinaButton.selected = NO;
    }
  //  NSLog(@"银行卡");
    dataType = 1;
}

@end

//
//  LowerControlViewControllerTwo.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/22.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "LowerControlViewControllerTwo.h"

@interface LowerControlViewControllerTwo ()

@end

@implementation LowerControlViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
       self.dataMonitorName.text = _deviceName;
    //设置圆角半径值
    self.xiaKView.layer.cornerRadius  = 10.f;
    //设置为遮罩，除非view有阴影，否则都要指定为YES的
    self.xiaKView.layer.masksToBounds = YES;
    
    [self.cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.okBtn addTarget:self action:@selector(setOkBtn) forControlEvents:(UIControlEventTouchUpInside)];
    

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
    
    
    self.xiaKView.userInteractionEnabled=YES;
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
    [self.xiaKView addGestureRecognizer:ggggg];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
    
    [self.view addGestureRecognizer:gesture];
    
    self.xiakValue.delegate = self;
    self.xiakValue.keyboardType = UIKeyboardTypeNumberPad;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 方式一
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    // 方式二
    // NSCharacterSet *charSet = [[NSCharacterSet  decimalDigitCharacterSet] invertedSet]];
    
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if ([string isEqualToString:filteredStr]) {
        return YES;
    }
    return NO;
}

-(void)tagGesture1 {
    [self.view endEditing:YES];
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
    
}
-(void)tagGesture2 {
    [self.view endEditing:YES];
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
    
    NSString *dataTypeStr = self.xiakValue.text;
    if ([self isBlankString:dataTypeStr]) {
        [self showToast:@"下控值不能为空"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(dataTypeStr);
    }
    [self tagGesture1];
}

@end

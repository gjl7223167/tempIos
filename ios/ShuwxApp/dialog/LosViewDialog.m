//
//  LosViewDialog.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LosViewDialog.h"

@interface LosViewDialog ()

@end

@implementation LosViewDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
           self.dataMonitorName.text = @"提交漏检说明";
        //设置圆角半径值
        self.xiakView.layer.cornerRadius  = 10.f;
        //设置为遮罩，除非view有阴影，否则都要指定为YES的
        self.xiakView.layer.masksToBounds = YES;
        
        [self.cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.okBtn addTarget:self action:@selector(setOkBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.xiakValue.placeholder = @"请输入漏检说明";
    
    NSString * hisStr = @"";
    _hisTitle = [Utils getIntegerValue:_hisTitle];
    hisStr =  [Utils getPinjieNSString:hisStr:@"还有"];
     hisStr =  [Utils getPinjieNSString:hisStr:_hisTitle];
      hisStr =  [Utils getPinjieNSString:hisStr:@"个点未提交，是否继续？"];
    self.hisTextView.text = hisStr;
        
        
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
        dataTypeStr = @"";
    }
    
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(dataTypeStr);
    }
    [self tagGesture1];
}

@end

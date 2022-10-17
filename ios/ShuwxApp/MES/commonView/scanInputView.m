//
//  scanInputView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "scanInputView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation scanInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews:frame];
    }
    return self;
}

-(void)initSubViews:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.4;
    backView.frame = self.bounds;
    [self addSubview:backView];
    
//    UIView *redview = [UIView new];
//    redview.backgroundColor = [UIColor redColor];
//    redview.frame = CGRectMake(0, 0, 200, 20);
//    [self addSubview:redview];
    CGFloat vWidth = frame.size.width - 100;
    CGFloat vHeight = 180;
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 6;
    whiteView.frame = CGRectMake(50, 250, vWidth, vHeight);
    [self addSubview:whiteView];
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.text = @"手动输入二维码/条形码编码";
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.frame = CGRectMake(15, 20, vWidth - 30, 20);
    [whiteView addSubview:infoLabel];
    
    self.contentTF = [[UITextField alloc] init];
    self.contentTF.frame = CGRectMake(15, 60, vWidth - 30, 30);
    self.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    self.contentTF.borderStyle = UITextBorderStyleRoundedRect;
    [whiteView addSubview:self.contentTF];
    
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
    cancelB.frame = CGRectMake(15, vHeight - 15 - 30, 60, 30);
    [whiteView addSubview:cancelB];
    
    UIButton *yesB = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesB setTitle:@"确定" forState:UIControlStateNormal];
    [yesB setTitleColor:RGBA(41, 36, 33, 1) forState:UIControlStateNormal];
    yesB.frame = CGRectMake(vWidth - 15 - 60, vHeight - 15 - 30, 60, 30);
    [whiteView addSubview:yesB];
    
    [cancelB addTarget:self action:@selector(cancellClick) forControlEvents:UIControlEventTouchUpInside];
    [yesB addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];

}

-(void)confirmClick
{
    [self.contentTF resignFirstResponder];
    NSString *content = self.contentTF.text;
    if (content.length > 0) {
        if (_InputContentB) {
            _InputContentB(content);
        }
    }
    else
    {
        if (_InputContentB) {
            _InputContentB(nil);
        }
    }
    
}

-(void)cancellClick
{
    [self.contentTF resignFirstResponder];
    if (_InputContentB) {
        _InputContentB(nil);
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

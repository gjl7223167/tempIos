//
//  AlartDetailsViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "AlartDetailsViewController.h"

@interface AlartDetailsViewController ()

@end

@implementation AlartDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //设置圆角半径值
      self.alartView.layer.cornerRadius  = 10.f;
      //设置为遮罩，除非view有阴影，否则都要指定为YES的
      self.alartView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
       [self.alartView addGestureRecognizer:ggggg];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
       
       [self.view addGestureRecognizer:gesture];
    
      [_alartButton addTarget:self action:@selector(tagGesture1) forControlEvents:UIControlEventTouchUpInside];
    
    _alartTextView.text = _alartTextString;
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
    
}

@end

//
//  AlartDetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"

@interface AlartDetailsViewController : MainViewController

@property (strong, nonatomic) IBOutlet UIView *alartView;

@property (strong, nonatomic) IBOutlet UIButton *alartButton;

@property (strong, nonatomic) IBOutlet UITextView *alartTextView;

@property (strong, nonatomic) NSString * alartTextString;

@end


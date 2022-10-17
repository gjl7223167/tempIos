//
//  WbConditionViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"

@interface WbConditionViewController : MainViewController

@property (strong, nonatomic) IBOutlet UIView *viewbg;
@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong,nonatomic) NSString * content_in_id;
@property (strong, nonatomic) IBOutlet UIView *weibContentView;

@property (strong, nonatomic) IBOutlet UIButton *closeButton;


@end


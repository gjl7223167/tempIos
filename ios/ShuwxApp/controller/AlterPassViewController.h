//
//  AlterPassViewController.h
//  ShuwxApp
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseConst.h"
#import <UMCommon/MobClick.h>
@interface AlterPassViewController : MainViewController
@property (strong, nonatomic) IBOutlet UITextField *myNewPass;
@property (strong, nonatomic) IBOutlet UITextField *myNewPassTwo;
@property (strong, nonatomic) IBOutlet UITextField *myOldPass;
@property (strong, nonatomic) IBOutlet UIButton *subButton;

@property (strong, nonatomic) IBOutlet UIView *allView;



@end


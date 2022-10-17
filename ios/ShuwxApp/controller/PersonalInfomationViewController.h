//
//  PersonalInfomationViewController.h
//  ShuwxApp
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseConst.h"
#import "YSPhotoBrowser.h"    
#import "MYTapGestureRecognizer.h"
#import <UMCommon/MobClick.h>



@interface PersonalInfomationViewController : MainViewController

@property (strong, nonatomic) IBOutlet UILabel *loginName;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *sexName;
@property (strong, nonatomic) IBOutlet UILabel *yidongPhone;
@property (strong, nonatomic) IBOutlet UILabel *emailName;
@property (weak, nonatomic) IBOutlet UIImageView *touxImage;

@property (nonatomic, assign) KSImageManagerType imageManagerType;

@property (strong, nonatomic) IBOutlet UIView *allView;

@end


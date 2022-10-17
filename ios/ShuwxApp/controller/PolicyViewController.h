//
//  PolicyViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2021/4/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import <UMCommon/MobClick.h>

@interface PolicyViewController : MainViewController<UINavigationBarDelegate>

@property (nonatomic, strong) NSString * htmlContent;
@property (nonatomic, strong) NSString * webTitle;

@end


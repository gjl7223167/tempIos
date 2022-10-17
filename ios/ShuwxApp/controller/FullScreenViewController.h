//
//  FullScreenViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/6/17.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "ReportDeviceViewController.h"
#import <UMCommon/MobClick.h>

@interface FullScreenViewController : MainViewController<UINavigationBarDelegate>
@property (nonatomic, strong) NSString * htmlContent;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (nonatomic, strong) NSString * clickButton;

@end


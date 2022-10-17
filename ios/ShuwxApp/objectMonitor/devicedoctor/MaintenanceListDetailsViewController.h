//
//  MaintenanceListDetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "AddMainProjectViewController.h"
#import "MainContentViewController.h"
#import "MainContentLookViewController.h"
#import "ProLabel.h"

@interface MaintenanceListDetailsViewController : MainViewController

@property (strong,nonatomic) NSString * order_id;
@property (strong,nonatomic) NSString * curPosition;
@property (strong, nonatomic) UIView *linearOneUiView;
@property (strong, nonatomic) UIView *linearTwoUiView;

@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) IBOutlet UIView *optonal;

@property (strong, nonatomic) IBOutlet UIButton *addWebBtn;

@property (strong,nonatomic) NSMutableDictionary * dictionNsmu;

@property (strong, nonatomic) IBOutlet UILabel *gdName;

@property (strong, nonatomic) IBOutlet UIButton *wbListAll;
@property (strong, nonatomic) IBOutlet UIButton *wbOneView;

@property (strong, nonatomic) IBOutlet UIButton *abovtButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSString *statusStr;

@end


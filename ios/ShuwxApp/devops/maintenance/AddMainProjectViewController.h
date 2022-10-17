//
//  AddMainProjectViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "WbConditionViewController.h"

@interface AddMainProjectViewController : MainViewController

@property (strong,nonatomic) NSString * order_id;
@property (strong,nonatomic) NSMutableDictionary * dictionNsmu;
@property (strong, nonatomic) UIView *linearOneUiView;
@property (strong,nonatomic) NSString * curPosition;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong,nonatomic) NSMutableArray * selectArray;
@property (strong, nonatomic) IBOutlet UIButton *addMainButton;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end


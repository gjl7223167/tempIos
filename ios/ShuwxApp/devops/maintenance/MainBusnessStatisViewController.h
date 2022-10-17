//
//  MainBusnessStatisViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MainOrderCompleteViewController.h"
#import "MainOrderTypeRankViewController.h"

@interface MainBusnessStatisViewController : MainViewController
@property (strong, nonatomic) IBOutlet UIButton *orderCarryOutBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderBankBtn;

@property (strong, nonatomic) IBOutlet UIView *allView;

@end


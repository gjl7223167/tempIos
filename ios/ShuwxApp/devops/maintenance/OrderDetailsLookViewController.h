//
//  OrderDetailsLookViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/8/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "DZStarView.h"
#import "Masonry.h"
#import "TransferOrderViewController.h"
#import "ProBtn.h"
#import "GuadResultViewController.h"
#import "CallReinforceViewController.h"
#import "HandleResultViewController.h"
#import "WorkJournalViewController.h"
#import "MainAssignViewViewController.h"
#import "RebootOrderViewController.h"
#import "NeedView.h"
#import "CancelOrderViewController.h"
#import "ApplyBackupViewController.h"
#import "ApplyTimeViewController.h"
#import "MainAppraisalViewController.h"
#import "MainWorkJournalViewController.h"
#import "ProcessOrderViewController.h"

@interface OrderDetailsLookViewController : MainViewController<DZStarViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *starOneView;
@property (strong, nonatomic) IBOutlet UIView *starTwoView;
@property (strong, nonatomic) IBOutlet UIView *starThreeView;
@property (strong,nonatomic) NSString * order_id;


@property (strong, nonatomic) IBOutlet UIView *linearoutwo;
@property (strong, nonatomic) IBOutlet UIView *linearouthree;
@property (strong, nonatomic) IBOutlet UIView *linearoutfour;
@property (strong, nonatomic) IBOutlet UIView *linearoutfive;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) UIView *linearOneUiView;

@property (strong, nonatomic) IBOutlet UIView *workLog;

@property (strong, nonatomic) IBOutlet UILabel *curState;
@property (strong, nonatomic) IBOutlet UILabel *curStateContent;
@property (strong, nonatomic) IBOutlet UILabel *curStateTime;

@property (strong,nonatomic) NSMutableDictionary * allDiction;


@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *orderType;
@property (strong, nonatomic) IBOutlet UILabel *baoxTime;
@property (strong, nonatomic) IBOutlet UILabel *baoxGoal;


@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) NSString *statusStr;

@property (strong, nonatomic) IBOutlet UIView *twoView;
@property (strong, nonatomic) NSMutableArray * curButtons;
@property (strong, nonatomic) IBOutlet UIView *buttonsList;
@end


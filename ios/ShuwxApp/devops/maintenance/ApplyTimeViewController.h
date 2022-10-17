//
//  ApplyTimeViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/22.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "NeedView.h"
#import "OrderRejectViewController.h"
#import "OrderDetailsLookViewController.h"

@interface ApplyTimeViewController : MainViewController

@property (strong,nonatomic) NSMutableDictionary * allDiction;

@property (nonatomic,strong) NSString * order_id;

@property (strong, nonatomic) IBOutlet UIView *devicelist;
@property (strong, nonatomic) IBOutlet UIView *linearoutwo;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *centerTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;

@property (strong, nonatomic) IBOutlet UIButton *noPassBtn;
@property (strong, nonatomic) IBOutlet UIButton *passBtn;

@property (strong, nonatomic) IBOutlet UIButton *orderDetailsButton;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end


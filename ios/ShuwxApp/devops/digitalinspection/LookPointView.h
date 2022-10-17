//
//  LookPointView.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "HitPointViewController.h"
#import "ProImageView.h"

#import "YSPhotoBrowser.h"    

@interface LookPointView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *uitableView;
@property (nonatomic,strong) NSMutableArray *dataSourceTwo;

// two
@property (weak, nonatomic) IBOutlet UILabel *pointNm;
@property (weak, nonatomic) IBOutlet UILabel *pointJcmb;
@property (weak, nonatomic) IBOutlet UILabel *pointWzxx;
@property (weak, nonatomic) IBOutlet UILabel *isShoud;
-(void)setList:(NSMutableArray *)dataSour;

@property (strong, nonatomic) UIViewController * myViewController;
@property (strong, nonatomic) NSMutableDictionary * pointDic;

@property (strong, nonatomic) IBOutlet UIView *jxmbView;

@property (strong, nonatomic) IBOutlet UIView *xjView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (nonatomic,strong) NSString * check_type;

@property (strong, nonatomic) IBOutlet UIView *deviceView;

@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *deviceCode;

@property (strong, nonatomic) NSString * target_device_code;

@property (strong, nonatomic) IBOutlet UIView *topOneView;

@property (strong, nonatomic) IBOutlet UIButton *aboveBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;


@end


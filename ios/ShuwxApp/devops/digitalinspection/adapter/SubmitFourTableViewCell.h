//
//  SubmitFourTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HitPointViewController.h"

@interface SubmitFourTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UITextField *shurkValue;
@property (weak, nonatomic) IBOutlet UILabel *shurkUnit;
@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (nonatomic, strong) NSString * curPosition;
@property (weak, nonatomic) UIViewController * myViewController;

@end


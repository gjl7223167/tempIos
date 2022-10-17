//
//  PositionDetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "ShowRepairViewController.h"

@interface PositionDetailsViewController : MainViewController
@property (strong, nonatomic) IBOutlet UILabel *posName;
@property (strong, nonatomic) NSString * deviceuuid;
@property (strong, nonatomic) IBOutlet UIButton *bottomPic;
@property (strong, nonatomic) NSString * devicetype;



@end


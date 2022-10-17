//
//  InspectionListDetailsViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"

@interface InspectionListDetailsViewController : MainViewController

@property (strong, nonatomic) NSString * point_id;
@property (strong, nonatomic) NSString * job_id;
@property (strong, nonatomic) NSString * check_type;
@property (strong, nonatomic) NSString * target_type;
@property (strong, nonatomic) NSString * position;
@property (strong, nonatomic) NSString * point_name;
@property (strong, nonatomic) NSString * target_device_name;
@property (strong, nonatomic) NSString * target_position_detail;
@property (strong, nonatomic) NSString * pos_name;
@property (strong, nonatomic) NSString * point_target;
@property (strong, nonatomic) NSString * is_sort;
@property (strong, nonatomic) NSString * target_device_code;


@end


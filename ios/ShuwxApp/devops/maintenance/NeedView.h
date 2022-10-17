//
//  NeedView.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/4.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface NeedView : UIView

@property (strong, nonatomic) IBOutlet UILabel *webName;
@property (strong, nonatomic) IBOutlet UIView *deviceView;
@property (strong, nonatomic) IBOutlet UIView *oneView;
@property (strong, nonatomic) IBOutlet UIView *twoView;
@property (strong, nonatomic) IBOutlet UILabel *needTextView;
@property (strong, nonatomic) IBOutlet UILabel *optoolTextView;
@property (strong, nonatomic) IBOutlet UIView *needView;
@property (strong, nonatomic) IBOutlet UIView *noRequstView;

@property (strong, nonatomic) IBOutlet UIView *gpsAllView;
@property (strong, nonatomic) IBOutlet UILabel *gpsContentValue;
@property (strong, nonatomic) IBOutlet UILabel *resetGpsView;
@property (strong, nonatomic) IBOutlet ProBtn *ddPointButton;
@property (strong, nonatomic) NSString * device_latitude;
@property (strong, nonatomic) NSString * device_longitude;

@end


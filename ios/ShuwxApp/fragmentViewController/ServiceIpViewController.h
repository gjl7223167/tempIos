//
//  ServiceIpViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/22.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "CompanyInfoOkViewController.h"


@interface ServiceIpViewController : LoginBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *serviceCotent;
@property (weak, nonatomic) IBOutlet UIView *backClick;
@property (nonatomic,strong) NSString * companyName;
@end


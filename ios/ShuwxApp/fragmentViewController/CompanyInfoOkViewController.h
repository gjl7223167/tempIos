//
//  CompanyInfoOkViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/22.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "ServiceIpViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "CKAlertViewController.h"

@interface CompanyInfoOkViewController : LoginBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *companOkBtn;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyIpAddress;
@property (weak, nonatomic) IBOutlet UIImageView *picLogo;
@property (nonatomic,strong) NSMutableDictionary *dicTable;
@end


//
//  TwoTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface TwoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *strategyName;
@property (strong, nonatomic) IBOutlet UILabel *strateDesci;

@property (strong, nonatomic) IBOutlet ProBtn *twoButton;

@end


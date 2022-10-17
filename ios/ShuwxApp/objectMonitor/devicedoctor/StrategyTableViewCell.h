//
//  StrategyTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface StrategyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *strateName;
@property (strong, nonatomic) IBOutlet UILabel *strateDescrip;
@property (strong, nonatomic) IBOutlet UILabel *curValue;
@property (strong, nonatomic) IBOutlet UITextField *sdValue;
@property (strong, nonatomic) IBOutlet UILabel *unitValue;
@property (strong, nonatomic) IBOutlet ProBtn *useCurBtn;


@end


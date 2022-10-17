//
//  ShuProManagerTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/15.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface ShuProManagerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *fuzePerson;
@property (weak, nonatomic) IBOutlet UILabel *proAddress;

@property (weak, nonatomic) IBOutlet UIImageView *picImage;

@property (weak, nonatomic) IBOutlet UILabel *alarmSum;
@property (weak, nonatomic) IBOutlet UILabel *obtype;
@property (weak, nonatomic) IBOutlet UIImageView *tubone;
@property (weak, nonatomic) IBOutlet UIImageView *tubtwo;

@property (strong, nonatomic) IBOutlet UILabel *objectState;

@end


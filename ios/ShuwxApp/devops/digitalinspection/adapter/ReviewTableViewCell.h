//
//  ReviewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *orderCode;
@property (weak, nonatomic) IBOutlet UIButton *wuxuXj;
@property (weak, nonatomic) IBOutlet UILabel *mytaskName;
@property (weak, nonatomic) IBOutlet UILabel *mytaskTime;
@property (weak, nonatomic) IBOutlet UILabel *mytaskdescri;

@property (strong, nonatomic) IBOutlet UILabel *zxPerson;
@property (strong, nonatomic) IBOutlet UILabel *jsSum;

@end


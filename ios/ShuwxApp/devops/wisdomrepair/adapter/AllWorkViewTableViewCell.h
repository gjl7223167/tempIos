//
//  AllWorkViewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/16.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllWorkViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *orderCode;

@property (weak, nonatomic) IBOutlet UIButton *wuxuXj;
@property (weak, nonatomic) IBOutlet UILabel *mytaskName;
@property (weak, nonatomic) IBOutlet UILabel *mytaskTime;
@property (weak, nonatomic) IBOutlet UILabel *mytaskdescri;
@property (strong, nonatomic) IBOutlet UIImageView *orverTime;


@end


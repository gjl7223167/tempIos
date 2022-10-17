//
//  InspectionEventTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *orderCode;
@property (weak, nonatomic) IBOutlet UIButton *wuxXj;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
@property (weak, nonatomic) IBOutlet UILabel *taskDescre;

@end


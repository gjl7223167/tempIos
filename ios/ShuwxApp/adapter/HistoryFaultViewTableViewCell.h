//
//  HistoryFaultViewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/18.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@interface HistoryFaultViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bjName;
@property (weak, nonatomic) IBOutlet UILabel *bjDesc;
@property (weak, nonatomic) IBOutlet UILabel *bjDate;
@property (weak, nonatomic) IBOutlet ProBtn *hisfaultbg;
@property (weak, nonatomic) IBOutlet UILabel *bjTitle;

@end


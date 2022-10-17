//
//  InspectionListTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *cellTime;
@property (strong, nonatomic) IBOutlet UILabel *oneName;
@property (strong, nonatomic) IBOutlet UILabel *oneNameValue;
@property (strong, nonatomic) IBOutlet UILabel *twoName;
@property (strong, nonatomic) IBOutlet UILabel *twoNameValue;
@property (strong, nonatomic) IBOutlet UILabel *threeName;
@property (strong, nonatomic) IBOutlet UILabel *threeNameValue;


@end


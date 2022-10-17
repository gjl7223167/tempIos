//
//  WorkPropertyTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/9.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "propertyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkPropertyTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property(nonatomic,strong) propertyModel *propertyM;
@property(nonatomic,strong) NSDictionary *valueDic;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end

NS_ASSUME_NONNULL_END

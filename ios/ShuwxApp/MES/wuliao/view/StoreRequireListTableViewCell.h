//
//  StoreRequireListTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "propertyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreRequireListTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) propertyModel *propertyM;
@property(nonatomic,strong) NSDictionary *valueDic;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;



@end

NS_ASSUME_NONNULL_END

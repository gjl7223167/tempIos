//
//  workStyleOneTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "propertyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface workStyleOneTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property(nonatomic,strong) propertyModel *propertyM;
@property(nonatomic,strong) NSDictionary *valueDic;

@property(nonatomic,strong) NSDictionary *titleDic;
@property(nonatomic,strong) NSDictionary *rightValueDic;


@end

NS_ASSUME_NONNULL_END

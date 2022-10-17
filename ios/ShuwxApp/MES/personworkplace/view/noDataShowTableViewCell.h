//
//  noDataShowTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/4.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface noDataShowTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *alertContentL;


@end

NS_ASSUME_NONNULL_END

//
//  PositionLeftTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/3.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PositionLeftTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

NS_ASSUME_NONNULL_END

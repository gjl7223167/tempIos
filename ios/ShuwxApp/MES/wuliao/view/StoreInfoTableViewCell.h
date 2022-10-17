//
//  StoreInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/27.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubTitleLabel;




@end

NS_ASSUME_NONNULL_END

//
//  WorkOperatorTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkOperatorTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

NS_ASSUME_NONNULL_END

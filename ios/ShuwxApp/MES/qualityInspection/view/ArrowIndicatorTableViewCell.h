//
//  ArrowIndicatorTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/16.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrowIndicatorTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end

NS_ASSUME_NONNULL_END

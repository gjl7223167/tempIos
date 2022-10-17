//
//  QualityMainBottomTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/15.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QualityMainBottomTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;



@end

NS_ASSUME_NONNULL_END

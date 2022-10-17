//
//  commonShowTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/4.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "progressShowView.h"

NS_ASSUME_NONNULL_BEGIN

@interface commonShowTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) progressShowView *progresV;
@end

NS_ASSUME_NONNULL_END

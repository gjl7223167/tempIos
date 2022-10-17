//
//  TypeThreeTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/28.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TypeThreeTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@end

NS_ASSUME_NONNULL_END

//
//  StoreTypeSelectTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreTypeSelectTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UITextField *chooseTF;



@end

NS_ASSUME_NONNULL_END

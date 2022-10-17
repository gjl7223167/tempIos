//
//  InOutRequireTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InOutRequireTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *NUmL;
@property (weak, nonatomic) IBOutlet UILabel *DateL;

@property (weak, nonatomic) IBOutlet UIButton *StoreBtn;

@property (nonatomic ,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

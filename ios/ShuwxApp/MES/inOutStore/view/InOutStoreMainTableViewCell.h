//
//  InOutStoreMainTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/9.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InOutStoreMainTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property(strong,nonatomic) NSDictionary *dataDic;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;


@end

NS_ASSUME_NONNULL_END

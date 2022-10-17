//
//  QualityPlanTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/18.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QualityPlanTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceC;


@property(nonatomic ,strong)NSDictionary *dataDic;
@property (nonatomic ,strong)NSString *status;

@end

NS_ASSUME_NONNULL_END

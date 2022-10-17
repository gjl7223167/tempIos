//
//  StoreRequireTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/19.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreRequireTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *orderN;
@property (weak, nonatomic) IBOutlet UILabel *materialName;
@property (weak, nonatomic) IBOutlet UILabel *specsN;
@property (weak, nonatomic) IBOutlet UILabel *requireN;
@property (weak, nonatomic) IBOutlet UILabel *hadN;
@property (weak, nonatomic) IBOutlet UILabel *oweN;

@property (weak, nonatomic) IBOutlet UILabel *hadTitleL;


@property(nonatomic ,strong)NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END

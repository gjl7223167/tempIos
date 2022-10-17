//
//  UnqualityHandleListTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/30.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnqualityHandleListTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *statusImgV;


@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel1;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel2;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel3;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel4;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel5;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *unqualityBtn;


@end

NS_ASSUME_NONNULL_END

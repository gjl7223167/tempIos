//
//  workTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface workTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;


@property(nonatomic ,strong)NSDictionary *dataDic;


@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel1;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel2;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel3;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel4;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel5;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel6;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel7;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel8;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property(nonatomic,strong)NSString *status;

@end

NS_ASSUME_NONNULL_END

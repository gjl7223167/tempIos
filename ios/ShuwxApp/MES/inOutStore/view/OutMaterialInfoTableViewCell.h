//
//  OutMaterialInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/10.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutMaterialInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(strong,nonatomic) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIButton *foldBtn;



@property (weak, nonatomic) IBOutlet UILabel *serialNumL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *batchNoL;
@property (weak, nonatomic) IBOutlet UILabel *NumL;
@property (weak, nonatomic) IBOutlet UILabel *positionL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *supplierL;
@property (weak, nonatomic) IBOutlet UILabel *produceL;



@end

NS_ASSUME_NONNULL_END

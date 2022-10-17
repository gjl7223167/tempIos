//
//  StoreMaterialInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreMaterialInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *SerialNumberL;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *TypeL;
@property (weak, nonatomic) IBOutlet UILabel *batchL;
@property (weak, nonatomic) IBOutlet UILabel *NumberL;
@property (weak, nonatomic) IBOutlet UILabel *LocationL;
@property (weak, nonatomic) IBOutlet UILabel *SupplierL;
@property (weak, nonatomic) IBOutlet UILabel *ProduceL;

@property(strong,nonatomic) NSDictionary *dataDic;



@end

NS_ASSUME_NONNULL_END

//
//  EditInStoreInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditInStoreInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *TypeL;
@property (weak, nonatomic) IBOutlet UILabel *batchL;
@property (weak, nonatomic) IBOutlet UITextField *NumberTF;
@property (weak, nonatomic) IBOutlet UIButton *PositionScanBtn;
@property (weak, nonatomic) IBOutlet UIButton *PositionChooseBtn;
@property (weak, nonatomic) IBOutlet UITextField *PositionTF;
@property (weak, nonatomic) IBOutlet UIButton *SupplierBtn;
@property (weak, nonatomic) IBOutlet UITextField *SupplierTF;
@property (weak, nonatomic) IBOutlet UIButton *ProduceBtn;
@property (weak, nonatomic) IBOutlet UITextField *ProduceTF;

@property(strong,nonatomic) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

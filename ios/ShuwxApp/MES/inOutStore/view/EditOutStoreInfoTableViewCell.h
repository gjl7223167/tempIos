//
//  EditOutStoreInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditOutStoreInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *foldBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *supplierL;
@property (weak, nonatomic) IBOutlet UILabel *produceL;
@property (weak, nonatomic) IBOutlet UIButton *positionScanBtn;
@property (weak, nonatomic) IBOutlet UIButton *positionChooseBtn;
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet UILabel *batchL;
@property (weak, nonatomic) IBOutlet UILabel *remainNumL;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;


@property(strong,nonatomic) NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END

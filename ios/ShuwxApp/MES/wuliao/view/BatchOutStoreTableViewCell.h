//
//  BatchOutStoreTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/20.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatchOutStoreTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *BatchNumL;

@property (weak, nonatomic) IBOutlet UITextField *NumTF;

@property(nonatomic ,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *scanImgV;
@property (weak, nonatomic) IBOutlet UIButton *OutStoreLocationScanBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCon;

@property(nonatomic ,assign) BOOL fromScan;



@end

NS_ASSUME_NONNULL_END

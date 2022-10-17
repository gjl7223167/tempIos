//
//  StoreRequireListBottomTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreRequireListBottomTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *voucherDetailBtn;

@property (weak, nonatomic) IBOutlet UIButton *storeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCon;

-(void)updateSubViewsStyle:(BOOL)isInStore state:(BOOL)isOneBtn;

@end

NS_ASSUME_NONNULL_END

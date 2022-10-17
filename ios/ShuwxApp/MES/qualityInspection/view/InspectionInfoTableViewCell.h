//
//  InspectionInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InspectionInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleL;

@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UILabel *rightL;

@property (nonatomic ,strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END

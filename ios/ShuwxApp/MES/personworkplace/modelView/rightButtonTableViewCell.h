//
//  rightButtonTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface rightButtonTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

-(void)cellSetStatus:(NSString *)status;

@end

NS_ASSUME_NONNULL_END

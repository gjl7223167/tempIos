//
//  MeTableViewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2018/12/24.
//  Copyright © 2018 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeTableViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *meNamePic;
@property (weak, nonatomic) IBOutlet UILabel *meLabelName;
@property (weak, nonatomic) IBOutlet UIImageView *showNext;
@property (weak, nonatomic) IBOutlet UIView *showTopView;
@property (weak, nonatomic) IBOutlet UILabel *exitLogin;
@property (weak, nonatomic) IBOutlet UILabel *verionLabel;

@end


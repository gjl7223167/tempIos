//
//  UnqualityHandleTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/22.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnqualityHandleTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *unqualityCodeL;
@property (weak, nonatomic) IBOutlet UILabel *qualityPlanL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *serialCodeL;
@property (weak, nonatomic) IBOutlet UITextField *NumberTF;


@property(nonatomic,strong)NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END

//
//  UnqualityBaseInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnqualityBaseInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *unqualityHandleCodeL;
@property (weak, nonatomic) IBOutlet UILabel *workCodeL;
@property (weak, nonatomic) IBOutlet UILabel *qualityPlanCodeL;
@property (weak, nonatomic) IBOutlet UILabel *inspectionTypeL;
@property (weak, nonatomic) IBOutlet UILabel *mateialNameL;
@property (weak, nonatomic) IBOutlet UILabel *unqualityNumL;
@property (weak, nonatomic) IBOutlet UILabel *createNameL;
@property (weak, nonatomic) IBOutlet UILabel *createTimeL;




@end

NS_ASSUME_NONNULL_END

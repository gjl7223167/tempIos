//
//  DefectInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarksView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefectInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UILabel *inspectionL;
@property (weak, nonatomic) IBOutlet UILabel *defectL;
@property (weak, nonatomic) IBOutlet UILabel *defectNumL;
@property (weak, nonatomic) IBOutlet RemarksView *markV;

@property (nonatomic ,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

//
//  AddDefectInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarksView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddDefectInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *inspectionBtn;
@property (weak, nonatomic) IBOutlet UITextField *inspectionTF;
@property (weak, nonatomic) IBOutlet UIButton *defectBtn;
@property (weak, nonatomic) IBOutlet UITextField *defectTF;

@property (weak, nonatomic) IBOutlet UITextField *defectNumTF;

@property (weak, nonatomic) IBOutlet RemarksView *markV;

@property (nonatomic ,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

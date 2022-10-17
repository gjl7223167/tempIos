//
//  InspectionResultTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/17.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InspectionResultTableViewCell : UITableViewCell<UITextFieldDelegate>

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UITextField *qualifiedNumTF;
@property (weak, nonatomic) IBOutlet UITextField *unqualifiedNumTF;
@property (weak, nonatomic) IBOutlet UITextField *inspectionNumTF;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *personL;

@property(nonatomic ,strong)NSDictionary *dataDic;
@property(nonatomic ,assign)BOOL canEditable;

@end

NS_ASSUME_NONNULL_END

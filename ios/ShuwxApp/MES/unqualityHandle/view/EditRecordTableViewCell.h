//
//  EditRecordTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/8.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditRecordTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UITextField *reasonTF;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@property (weak, nonatomic) IBOutlet UIButton *suggestBtn;
@property (weak, nonatomic) IBOutlet UITextField *suggestTF;





@end

NS_ASSUME_NONNULL_END

//
//  TypeOneTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/28.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NSTransferBlock)(NSString *);
@interface TypeOneTableViewCell : UITableViewCell<UITextFieldDelegate>

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (nonatomic ,copy) NSTransferBlock GetValueB;

@end

NS_ASSUME_NONNULL_END

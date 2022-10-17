//
//  OutBillInfoTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/10.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutBillInfoTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(strong,nonatomic) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *businissNumberL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *operatorL;
@property (weak, nonatomic) IBOutlet UILabel *harvesterL;


@end

NS_ASSUME_NONNULL_END

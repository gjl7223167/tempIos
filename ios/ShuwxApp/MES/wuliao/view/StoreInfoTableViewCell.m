//
//  StoreInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/27.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreInfoTableViewCell.h"

@implementation StoreInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    StoreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

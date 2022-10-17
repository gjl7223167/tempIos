//
//  rightButtonTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "rightButtonTableViewCell.h"

@implementation rightButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    rightButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)cellSetStatus:(NSString *)status
{
    if ([status isEqualToString:@"POM_woStatus_02"]) {
        [self.rightBtn setTitle:@"开工" forState:UIControlStateNormal];
    }else if ([status isEqualToString:@"POM_woStatus_03"])
    {
        [self.rightBtn setTitle:@"记录" forState:UIControlStateNormal];

    }else if ([status isEqualToString:@"POM_woStatus_04"])
    {
        [self.rightBtn setTitle:@"恢复" forState:UIControlStateNormal];

    }else{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

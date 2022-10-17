//
//  InOutRequireTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InOutRequireTableViewCell.h"

@implementation InOutRequireTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    InOutRequireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (dataDic) {
        _dataDic = dataDic;
        
        self.TitleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"businessCode"]];
        self.typeL.text = [NSString stringWithFormat:@"%@",dataDic[@"businessTypeName"]];
        self.NUmL.text = [NSString stringWithFormat:@"%@",dataDic[@"businessId"]];
        self.DateL.text = [NSString stringWithFormat:@"%@",dataDic[@"createTime"]];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

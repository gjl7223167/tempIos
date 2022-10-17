//
//  InOutStoreMainTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/9.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InOutStoreMainTableViewCell.h"

@implementation InOutStoreMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    InOutStoreMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"code"]];
        self.typeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"typeName"]];
        self.createLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"createUserName"]];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"createTime"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

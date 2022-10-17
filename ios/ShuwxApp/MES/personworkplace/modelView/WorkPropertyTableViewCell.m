//
//  WorkPropertyTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/9.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WorkPropertyTableViewCell.h"

@implementation WorkPropertyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    WorkPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setPropertyM:(propertyModel *)propertyM
{
    if (propertyM) {
        _propertyM = propertyM;
        self.titleL.text = [NSString stringWithFormat:@"%@：",propertyM.elementLabel];
    }
}

- (void)setValueDic:(NSDictionary *)valueDic
{
    if (valueDic) {
        _valueDic = valueDic;
        self.subTitle.text = [NSString stringWithFormat:@"%@",valueDic[_propertyM.code]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

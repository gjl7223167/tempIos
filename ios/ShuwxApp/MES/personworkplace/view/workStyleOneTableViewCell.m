//
//  workStyleOneTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "workStyleOneTableViewCell.h"

@implementation workStyleOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    workStyleOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        self.leftLabel.text = [NSString stringWithFormat:@"%@：",propertyM.elementLabel];
    }
}

- (void)setValueDic:(NSDictionary *)valueDic
{
    if (valueDic) {
        _valueDic = valueDic;
        self.rightLabel.text = [NSString stringWithFormat:@"%@",valueDic[_propertyM.code]];
    }
}

- (void)setTitleDic:(NSDictionary *)titleDic
{
    if (titleDic) {
        _titleDic = titleDic;
        NSArray *valueArr = titleDic.allValues;
        self.leftLabel.text = [NSString stringWithFormat:@"%@",valueArr.firstObject];
    }
}

- (void)setRightValueDic:(NSDictionary *)rightValueDic
{
    if (rightValueDic) {
        _rightValueDic = rightValueDic;
        NSArray *keyArr = _titleDic.allKeys;
        self.rightLabel.text = [NSString stringWithFormat:@"%@",rightValueDic[keyArr.firstObject]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  UnqualityBaseInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityBaseInfoTableViewCell.h"

@implementation UnqualityBaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    UnqualityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.unqualityHandleCodeL.text = [self getStringWith:dataDic[@"code"]];
        self.workCodeL.text = [self getStringWith:dataDic[@"productSegmentCode"]];
        self.qualityPlanCodeL.text = [self getStringWith:dataDic[@"qualityCode"]];
        self.inspectionTypeL.text = [self getStringWith:dataDic[@"inspectionTypeName"]];
        self.mateialNameL.text = [self getStringWith:dataDic[@"materialName"]];
        self.unqualityNumL.text = [self getStringWith:dataDic[@"quantity"]];
        self.createNameL.text = [self getStringWith:dataDic[@"createUserName"]];
        self.createTimeL.text = [self getStringWith:dataDic[@"createTime"]];
    }
}

-(NSString *)getStringWith:(id)Str
{
    if ([Str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",Str];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

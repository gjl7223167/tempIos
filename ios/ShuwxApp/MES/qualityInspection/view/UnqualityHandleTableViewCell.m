//
//  UnqualityHandleTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/22.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityHandleTableViewCell.h"

@implementation UnqualityHandleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    UnqualityHandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.qualityPlanL.text = [NSString stringWithFormat:@"%@",dataDic[@"code"]];
        self.typeL.text = [NSString stringWithFormat:@"%@",[self getStringWith:dataDic[@"inspectionTypeName"]]];
        self.nameL.text = [NSString stringWithFormat:@"%@",dataDic[@"productSegmentName"]];
        self.serialCodeL.text = [NSString stringWithFormat:@"%@",dataDic[@"productSegmentCode"]];
        
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

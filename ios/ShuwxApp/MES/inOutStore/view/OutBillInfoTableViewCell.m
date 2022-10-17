//
//  OutBillInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/10.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "OutBillInfoTableViewCell.h"

@implementation OutBillInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    OutBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        self.codeL.text = [self isNullString:dataDic[@"code"]];
        self.typeL.text = [self isNullString:dataDic[@"typeName"]];
        self.businissNumberL.text = [self isNullString:dataDic[@"businessCode"]];
//        self.dateL.text = [self isNullString:dataDic[@"realDeliveryDate"]];
        self.dateL.text = [self isNullString:dataDic[@"createTime"]];
        self.operatorL.text = [self isNullString:dataDic[@"createUserName"]];
        self.harvesterL.text = [self isNullString:dataDic[@"receiverName"]];
    }
}


- (NSString *)isNullString:(id)string {
    if (string == nil || string == NULL) {
        return @"";
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([string isMemberOfClass:[NSString class]]) {
            if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]) {
                return @"";
            }
    }
    
    return [NSString stringWithFormat:@"%@",string];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

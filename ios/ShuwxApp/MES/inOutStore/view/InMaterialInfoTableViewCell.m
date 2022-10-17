//
//  InMaterialInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/10.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InMaterialInfoTableViewCell.h"

@implementation InMaterialInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    InMaterialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.titleL.text = [NSString stringWithFormat:@"%@   %@",[self isNullString:dataDic[@"materialCode"]],[self isNullString:dataDic[@"materialName"]]];
        self.batchNoL.text = [self isNullString:dataDic[@"batchNo"]];
        self.NumL.text = [self isNullString:dataDic[@"balanceQty"]];
        self.positionL.text = [self isNullString:dataDic[@"positionName"]];
        self.typeL.text = [self isNullString:dataDic[@"typeName"]];
        self.supplierL.text = [self isNullString:dataDic[@"supplierName"]];
        self.produceL.text = [self isNullString:dataDic[@"manufacturerName"]];
        
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

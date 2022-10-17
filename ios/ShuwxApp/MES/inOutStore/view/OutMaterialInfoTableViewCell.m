//
//  OutMaterialInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/10.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "OutMaterialInfoTableViewCell.h"

@implementation OutMaterialInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    OutMaterialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
/*
 {
     balanceQty = 55;
     batchNo = "<null>";
     checkBillId = "<null>";
     checkQty = "<null>";
     createTime = "2020-12-16 10:44:35";
     demandQty = "<null>";
     desc = "<null>";
     id = "<null>";
     manufacturerId = "<null>";
     manufacturerName = "<null>";
     materialCode = "\U534a\U6210\U54c1-0001";
     materialId = 205;
     materialName = iphone15;
     parentId = "<null>";
     positionId = "<null>";
     positionName = "<null>";
     qty = "<null>";
     remark = "<null>";
     spec = "default_value\U6d4b\U8bd5";
     stockId = "<null>";
     supplierId = "<null>";
     supplierName = "<null>";
     totalQty = "<null>";
     type = 76;
     typeId = 76;
     typeName = "q2q/0006\U534a\U6210\U54c1";
     unitId = 19;
     unitName = "\U5f20";
 }
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  StoreMaterialInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreMaterialInfoTableViewCell.h"

@implementation StoreMaterialInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    StoreMaterialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.TitleLabel.text = [NSString stringWithFormat:@"%@  %@",dataDic[@"code"],dataDic[@"name"]];
        self.TypeL.text = [NSString stringWithFormat:@"%@",dataDic[@"spec"]];
        self.batchL.text = [NSString stringWithFormat:@"%@",dataDic[@"batchNo"]];
        self.NumberL.text = [NSString stringWithFormat:@"%@",dataDic[@"inQty"]];
        self.LocationL.text = [NSString stringWithFormat:@"%@",dataDic[@"positionName"]];
        self.SupplierL.text = [NSString stringWithFormat:@"%@",dataDic[@"supplierName"]];
        self.ProduceL.text = [NSString stringWithFormat:@"%@",dataDic[@"manufacturerName"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

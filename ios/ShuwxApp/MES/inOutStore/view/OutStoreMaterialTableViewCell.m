//
//  OutStoreMaterialTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/2.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "OutStoreMaterialTableViewCell.h"

@implementation OutStoreMaterialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    OutStoreMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",dataDic[@"materialCode"],dataDic[@"materialName"]];
        self.typeL.text = [NSString stringWithFormat:@"%@",dataDic[@"spec"]];
        self.batchL.text = [NSString stringWithFormat:@"%@",dataDic[@"batchNo"]];
        self.supplierL.text = [NSString stringWithFormat:@"%@",dataDic[@"supplierName"]];
        self.produceL.text = [NSString stringWithFormat:@"%@",dataDic[@"manufacturerName"]];
        self.locationL.text = [NSString stringWithFormat:@"%@",dataDic[@"positionName"]];
        self.remainNumL.text = [NSString stringWithFormat:@"%@",dataDic[@"qty"]];
        self.numberL.text = [NSString stringWithFormat:@"%@",dataDic[@"outQty"]];;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

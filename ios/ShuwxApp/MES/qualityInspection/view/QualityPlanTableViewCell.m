//
//  QualityPlanTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/18.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "QualityPlanTableViewCell.h"
#import "Tools.h"

@implementation QualityPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    QualityPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.titleLabel.text = [Tools getString:dataDic[@"materialName"]];
        self.firstLabel.text = [Tools getString:dataDic[@"code"]];
        self.secondLabel.text = [Tools getString:dataDic[@"inspectionTypeName"]];
        self.thirdLabel.text = [Tools getString:dataDic[@"productSegmentName"]];
        self.fourLabel.text = [Tools getString:dataDic[@"productionWorkOrderCode"]];
        self.fiveLabel.text = [Tools getString:dataDic[@"productionOrderCode"]];

        if ([self.status isEqualToString:@"QOM_Inspection_status_03"]) {
            self.distanceC.constant = 108;
            [self.skipBtn setTitle:@"不合格品处理" forState:UIControlStateNormal];
        }else
        {
            [self.skipBtn setTitle:@"检验记录" forState:UIControlStateNormal];
            self.distanceC.constant = 84;
        }
        
        NSString *imgname = @"";
        if ([self.status isEqualToString:@"QOM_Inspection_status_01"]) {
            imgname = @"daizx_t";

        }else if ([self.status isEqualToString:@"QOM_Inspection_status_02"])
        {
            imgname = @"zhixz_t";

        }else if ([self.status isEqualToString:@"QOM_Inspection_status_03"])
        {
            imgname = @"yiwc_t";

        }else{
            imgname = @"buhg_t";
        }
        
        self.imageV.image = [UIImage imageNamed:imgname];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

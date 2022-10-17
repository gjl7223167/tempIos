//
//  AddDefectInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "AddDefectInfoTableViewCell.h"

@implementation AddDefectInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.markV.contentTV.placeholder = @"请输入您的改进建议";

}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    AddDefectInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.inspectionTF.text = [NSString stringWithFormat:@"%@",dataDic[@"inspectionSubjectName"]];
        self.defectTF.text = [NSString stringWithFormat:@"%@",dataDic[@"defectSubjectName"]];
        self.defectNumTF.text = [NSString stringWithFormat:@"%@",dataDic[@"defectQty"]];
        self.markV.contentTV.text = [NSString stringWithFormat:@"%@",dataDic[@"suggest"]];
        self.markV.contentTV.placeholder = @"请输入您的改进建议";

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

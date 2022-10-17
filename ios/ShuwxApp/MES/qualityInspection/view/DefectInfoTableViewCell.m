//
//  DefectInfoTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "DefectInfoTableViewCell.h"

@implementation DefectInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.markV.contentTV.editable = NO;
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    DefectInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.inspectionL.text = [NSString stringWithFormat:@"%@",dataDic[@"inspectionSubjectName"]];
        self.defectL.text = [NSString stringWithFormat:@"%@",dataDic[@"defectSubjectName"]];
        self.defectNumL.text = [NSString stringWithFormat:@"%@",dataDic[@"defectQty"]];
        self.markV.contentTV.text = [NSString stringWithFormat:@"%@",dataDic[@"suggest"]];
        self.markV.contentTV.placeholder = @"";

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

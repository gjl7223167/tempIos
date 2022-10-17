//
//  workTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "workTableViewCell.h"

@implementation workTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    workTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (IBAction)bottomClick:(id)sender {
    
}
//{
//    code = "20201125-mes-123-abc-null-00002";
//    id = 2;
//    materialCode = wl001;
//    materialId = 11;
//    materialName = "\U7269\U6599001";
//    orderCode = "\U7269\U6599001null2020112500000001";
//    planEndTime = "2020-11-26 00:00:00";
//    planQty = 100;
//    planStartTime = "2020-11-25 00:00:00";
//    realEndTime = "<null>";
//    realStartTime = "2020-11-25 15:40:04";
//    segmentCode = 002;
//    segmentId = 3;
//    segmentName = "\U6253";
//    status = 806;
//    statusName = "\U4f5c\U4e1a\U4e2d";
//}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.titleL.text = dataDic[@"materialName"];
    self.centerLabel1.text = [NSString stringWithFormat:@"%@",dataDic[@"segmentCode"]];
    self.centerLabel2.text = dataDic[@"orderCode"];
    
    self.centerLabel3.text = dataDic[@"segmentName"];
    self.centerLabel4.text = [NSString stringWithFormat:@"%@",dataDic[@"planQty"]];
    self.centerLabel5.text = dataDic[@"planStartTime"];
    self.centerLabel6.text = dataDic[@"planEndTime"];
    self.centerLabel7.text = @"--";
    self.centerLabel8.text = @"--";
    if (dataDic[@"realStartTime"]&&(![self isNullString:dataDic[@"realStartTime"]])) {
        self.centerLabel7.text = dataDic[@"realStartTime"];
    }
    if (dataDic[@"realEndTime"]&&(![self isNullString:dataDic[@"realEndTime"]])) {
        self.centerLabel8.text = dataDic[@"realEndTime"];
    }
    
    if ([self.status isEqualToString:@"POM_woStatus_02"]) {
        [self.bottomBtn setTitle:@"开工" forState:UIControlStateNormal];
    }else if ([self.status isEqualToString:@"POM_woStatus_03"])
    {
        [self.bottomBtn setTitle:@"记录" forState:UIControlStateNormal];

    }else if ([self.status isEqualToString:@"POM_woStatus_04"])
    {
        [self.bottomBtn setTitle:@"恢复" forState:UIControlStateNormal];

    }else{

    }
        
}

- (BOOL)isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  BatchOutStoreTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/20.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BatchOutStoreTableViewCell.h"

@implementation BatchOutStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    BatchOutStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)setDataDic:(NSDictionary *)dataDic
{
    if (dataDic) {
        _dataDic = dataDic;
        
        self.BatchNumL.text = [self isNullString:dataDic[@"batchNo"]];
        self.rightTF.text = [self isNullString:dataDic[@"positionName"]];
        self.NumTF.text = [self isNullString:dataDic[@"qty"]];
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

- (void)setFromScan:(BOOL)fromScan
{
    _fromScan = fromScan;
    if (!fromScan) {
        self.scanImgV.hidden = YES;
        self.OutStoreLocationScanBtn.hidden = YES;
        self.rightImgV.hidden = YES;
        self.rightBtn.hidden = YES;
        self.rightCon.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  UnqualityHandleListTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/30.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnqualityHandleListTableViewCell.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation UnqualityHandleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = RGBA(0, 137, 255, 1).CGColor;
    
    
    self.statusImgV.hidden = YES;
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    UnqualityHandleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.titleL.text = [self getStringWith:dataDic[@"materialName"]];
        self.centerLabel1.text = [self getStringWith:dataDic[@"code"]];
        self.centerLabel2.text = [self getStringWith:dataDic[@"productSegmentCode"]];
        self.centerLabel3.text = [self getStringWith:dataDic[@"inspectionTypeName"]];
        self.centerLabel4.text = [self getStringWith:dataDic[@"qualityCode"]];
        self.centerLabel5.text = [self getStringWith:dataDic[@"createTime"]];
        
    }
}

-(NSString *)getStringWith:(id)Str
{
    if ([Str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",Str];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

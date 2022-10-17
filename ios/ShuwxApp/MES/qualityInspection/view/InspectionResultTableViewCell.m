//
//  InspectionResultTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/17.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "InspectionResultTableViewCell.h"

@implementation InspectionResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.qualifiedNumTF.delegate = self;
    self.unqualifiedNumTF.delegate = self;
    self.inspectionNumTF.delegate = self;
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifer =  NSStringFromClass([self class]);
    InspectionResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        
        self.qualifiedNumTF.text = [self getString:dataDic[@"qualifiedQty"]];
        self.unqualifiedNumTF.text = [self getString:dataDic[@"unqualifiedQty"]];
        self.inspectionNumTF.text = [self getString:dataDic[@"realInspectionQty"]];
        self.dateL.text = [self getString:dataDic[@"updateTime"]];
        self.personL.text = [self getString:dataDic[@"updateUserName"]];

    }
}


- (void)setCanEditable:(BOOL)canEditable
{
    _canEditable = canEditable;
    if (canEditable) {
        self.qualifiedNumTF.enabled = YES;
        self.unqualifiedNumTF.enabled = YES;
        self.inspectionNumTF.enabled = YES;
        if ([self.qualifiedNumTF.text isEqualToString:@"暂无"]) {
            self.qualifiedNumTF.text = @"";
        }
        if ([self.unqualifiedNumTF.text isEqualToString:@"暂无"]) {
            self.unqualifiedNumTF.text = @"";
        }
        if ([self.inspectionNumTF.text isEqualToString:@"暂无"]) {
            self.inspectionNumTF.text = @"";
        }
    }else{
        self.qualifiedNumTF.enabled = NO;
        self.unqualifiedNumTF.enabled = NO;
        self.inspectionNumTF.enabled = NO;
    }
}

-(NSString *)getString:(id)data
{
    if ([data isKindOfClass:[NSNull class]]) {
        return @"暂无";
    }
    return [NSString stringWithFormat:@"%@",data];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

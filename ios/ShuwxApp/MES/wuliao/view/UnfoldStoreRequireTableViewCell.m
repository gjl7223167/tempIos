//
//  UnfoldStoreRequireTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/20.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "UnfoldStoreRequireTableViewCell.h"

@implementation UnfoldStoreRequireTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    UnfoldStoreRequireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
        self.materialName.text = [NSString stringWithFormat:@"%@  %@",dataDic[@"materialCode"],dataDic[@"materialName"]];
        self.specsN.text = [NSString stringWithFormat:@"%@",dataDic[@"spec"]];
        self.requireN.text = [NSString stringWithFormat:@"%@",dataDic[@"demandQty"]];
        self.hadN.text = [NSString stringWithFormat:@"%@",dataDic[@"totalQty"]];
        int total = 0;
        int demand = 0;
        if (![self isNullString:dataDic[@"totalQty"]] ) {
            total = [dataDic[@"totalQty"] intValue];
        }
        if (![self isNullString:dataDic[@"demandQty"]] ) {
            demand = [dataDic[@"demandQty"] intValue];
        }
        self.oweN.text = [NSString stringWithFormat:@"%d",demand - total];

    }
}

- (BOOL)isNullString:(id)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isMemberOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        //        NSLog(@"bbbbb");
                return YES;
            }
            if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]) {
        //        NSLog(@"lllllll");
                return YES;
            }
    }
    
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

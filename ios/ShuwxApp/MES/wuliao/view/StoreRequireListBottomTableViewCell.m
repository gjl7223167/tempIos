//
//  StoreRequireListBottomTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "StoreRequireListBottomTableViewCell.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation StoreRequireListBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.voucherDetailBtn.hidden = YES;
}



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    StoreRequireListBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)updateSubViewsStyle:(BOOL)isInStore state:(BOOL)isOneBtn
{
    if (isInStore) {
        [self.storeBtn setTitle:@"入库" forState:UIControlStateNormal];
        
        /*
        if (isOneBtn) {
            self.detailCon.constant = 16;
            [self.voucherDetailBtn setTitle:@"票据详情" forState:UIControlStateNormal];
            [self.voucherDetailBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
            [self.voucherDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.storeBtn.hidden = YES;
        }
        else
        {
            self.detailCon.constant = 86;
            [self.voucherDetailBtn setTitle:@"票据详情" forState:UIControlStateNormal];
            [self.voucherDetailBtn setBackgroundColor:[UIColor whiteColor]];
            [self.voucherDetailBtn setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
            self.voucherDetailBtn.layer.borderWidth = 1;
            self.voucherDetailBtn.layer.borderColor = RGBA(0, 137, 255, 1).CGColor;
            self.storeBtn.hidden = NO;
        }
         */
    }else{
        [self.storeBtn setTitle:@"出库" forState:UIControlStateNormal];
/*
        if (isOneBtn) {
            self.detailCon.constant = 16;
            [self.voucherDetailBtn setTitle:@"需求详情" forState:UIControlStateNormal];
            [self.voucherDetailBtn setBackgroundColor:RGBA(0, 137, 255, 1)];
            [self.voucherDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.storeBtn.hidden = YES;
        }
        else
        {
            self.detailCon.constant = 86;
            [self.voucherDetailBtn setTitle:@"需求详情" forState:UIControlStateNormal];
            [self.voucherDetailBtn setBackgroundColor:[UIColor whiteColor]];
            [self.voucherDetailBtn setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
            self.voucherDetailBtn.layer.borderWidth = 1;
            self.voucherDetailBtn.layer.borderColor = RGBA(0, 137, 255, 1).CGColor;
            self.storeBtn.hidden = NO;
        }
 */
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

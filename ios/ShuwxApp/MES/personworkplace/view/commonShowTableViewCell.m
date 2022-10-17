//
//  commonShowTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/4.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "commonShowTableViewCell.h"
#import "progressShowView.h"

@implementation commonShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.progresV = [[progressShowView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    [self.progresV setProgress:30 part:20];

    [self.contentView addSubview:self.progresV];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    commonShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

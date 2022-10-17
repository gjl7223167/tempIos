//
//  PositionLeftTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/3.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "PositionLeftTableViewCell.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation PositionLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    PositionLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = RGBA(0, 137, 255, 1);
    }
    else
    {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.titleLabel.textColor = [UIColor blackColor];

    }
    // Configure the view for the selected state
}

@end

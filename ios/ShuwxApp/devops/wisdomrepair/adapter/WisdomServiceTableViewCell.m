//
//  WisdomServiceTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/15.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WisdomServiceTableViewCell.h"

@implementation WisdomServiceTableViewCell

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;    // 减掉的值就是分隔线的高度
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

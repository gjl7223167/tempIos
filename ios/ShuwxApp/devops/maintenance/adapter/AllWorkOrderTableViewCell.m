//
//  AllWorkOrderTableViewCell.m
//
//
//  Created by 袁小强 on 2020/6/2.
//  Copyright © 2020 天拓四方. All rights reserved.
//

#import "AllWorkOrderTableViewCell.h"

@implementation AllWorkOrderTableViewCell

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 5;    // 减掉的值就是分隔线的高度
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

//
//  FaultViewTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/7.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "FaultViewTableViewCell.h"

@implementation FaultViewTableViewCell

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

//
//  QianmingTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "QianmingTableViewCell.h"

@implementation QianmingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}

-(void)initView{
    self.titleOne.layer.cornerRadius = _titleOne.frame.size.width / 2;
    self.titleOne.clipsToBounds = YES;
    self.titleOne.layer.borderWidth = 1;
    self.titleOne.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:255.0/225.0 alpha:1] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

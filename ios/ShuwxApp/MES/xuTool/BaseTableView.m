//
//  BaseTableView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

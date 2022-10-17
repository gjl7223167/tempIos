//
//  SubOneCollectionViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SubOneCollectionViewCell.h"

@implementation SubOneCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code  UIScrollView
    [self initView];
}
-(void)initView{
    
    self.xuanxView.layer.cornerRadius = self.xuanxView.frame.size.width / 2;
    self.xuanxView.clipsToBounds = YES;
    self.xuanxView.layer.borderWidth = 1;
    self.xuanxView.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:225.0/255.0 alpha:1] CGColor];
    
}

@end

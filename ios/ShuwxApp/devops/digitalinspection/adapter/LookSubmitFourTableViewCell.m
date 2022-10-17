//
//  LookSubmitFourTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LookSubmitFourTableViewCell.h"

@implementation LookSubmitFourTableViewCell


- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;    // 减掉的值就是分隔线的高度
    [super setFrame:frame];
}

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
    
    
    // 1.给textField增加事件
    [self.shurkValue addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
// 2.回调
- (void)textFieldChanged:(UITextView *)textField
{
   
    NSString *text = textField.text;
    NSLog(@"inputString: %@", text);
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

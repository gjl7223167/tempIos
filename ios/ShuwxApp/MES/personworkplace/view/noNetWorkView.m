//
//  noNetWorkView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "noNetWorkView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation noNetWorkView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 105)];
        imagev.image = [UIImage imageNamed:@"noNet_i"];
        imagev.center = CGPointMake(frame.size.width/2.0, frame.size.height/4.0);
        [self addSubview:imagev];
        
        UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
        textL.center = CGPointMake(frame.size.width/2.0, imagev.center.y + 53 + 25 + 10);
        textL.text = @"网络开小差了，重试一下";
        textL.font = [UIFont systemFontOfSize:14];
        textL.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        textL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textL];
        
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [reloadBtn setTitleColor:RGBA(0, 137, 255, 1) forState:UIControlStateNormal];
        reloadBtn.frame = CGRectMake(0, 0, 75, 25);
        reloadBtn.center = CGPointMake(frame.size.width/2.0, textL.center.y + 10 + 30 + 15);
        reloadBtn.layer.masksToBounds = YES;
        reloadBtn.layer.cornerRadius = 8;
        reloadBtn.layer.borderWidth = 1;
        reloadBtn.layer.borderColor = RGBA(0, 137, 255, 1).CGColor;
        [self addSubview:reloadBtn];
        
        [reloadBtn addTarget:self action:@selector(reloadNetData) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;

}

-(void)reloadNetData
{
    if (_reloadB) {
        _reloadB();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

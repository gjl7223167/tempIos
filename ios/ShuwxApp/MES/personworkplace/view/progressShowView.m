//
//  progressShowView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/3.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "progressShowView.h"

@implementation progressShowView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        titleL.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        titleL.text = @"进度";
        titleL.frame = CGRectMake(16, 12, 60, 20);
        [self addSubview:titleL];
        
        self.Numlabel = [[UILabel alloc] init];
        self.Numlabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.Numlabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.Numlabel.text = @"当前完成：0件";
        self.Numlabel.frame = CGRectMake(16, 50, 200, 20);
        [self addSubview:self.Numlabel];
        
        
        self.myView = [[UIView alloc] initWithFrame:CGRectMake(16, 80, frame.size.width - 16*2, 20)];
        //设置背景颜色
        self.myView.backgroundColor = [UIColor whiteColor];
        //添加
        [self addSubview:self.myView];

        self.myView.layer.masksToBounds = YES;
        self.myView.layer.cornerRadius = 12;
        self.myView.layer.borderColor = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
        
        self.myView.layer.borderWidth = 1.0f;
        
        self.foreV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        self.foreV.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.foreV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
//
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        //设置大小
//        maskLayer.frame = self.foreV.bounds;
//        //设置图形样子
//        maskLayer.path = maskPath.CGPath;
//        self.foreV.layer.mask = maskLayer;
        [self.myView addSubview:self.foreV];

        self.textlabel = [[UILabel alloc] init];
        
        self.textlabel.textAlignment = NSTextAlignmentRight;
        self.textlabel.font = [UIFont systemFontOfSize:12];
        //文字颜色
        self.textlabel.textColor = [UIColor colorWithRed:22.0/255.0 green:119.0/255.0 blue:255.0/255.0 alpha:1];
        self.textlabel.frame = CGRectMake(0, 0, self.myView.frame.size.width - 10, 20);
        [self.myView addSubview: self.textlabel];
        
        
        UILabel *lineL = [[UILabel alloc] init];
        lineL.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
        lineL.frame = CGRectMake(16, 119, frame.size.width - 16*2, 0.5);
        [self addSubview:lineL];
    }
    return self;
}

-(void)setProgress:(NSInteger)total part:(NSInteger)part;
{
    
    self.foreV.frame = CGRectMake(0, 0, self.myView.frame.size.width*part/total, 20);
    
    self.textlabel.text = [NSString stringWithFormat:@"%d/%d",part,total];
    
    self.Numlabel.text = [NSString stringWithFormat:@"当前完成：%d件",part];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end

//
//  anLightView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "anLightView.h"
@interface anLightView()
{
    UIImageView *topImageV;
    UILabel *bottomLabel;
    UIButton *upBtn;
    NSMutableDictionary *statusDic;
}
@end
@implementation anLightView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    
    topImageV = [[UIImageView alloc] init];
    topImageV.frame = CGRectMake(40, 12, 24, 24);
    [self addSubview:topImageV];
    
    bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(0, 42, 105, 20);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:bottomLabel];
    
    upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(0, 0, 105, 71);
    [self addSubview:upBtn];
        
    
    statusDic = [NSMutableDictionary dictionaryWithCapacity:2];
}

-(void)viewAddTaget:(id)taget sel:(SEL)sel
{
    [upBtn addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
}



-(void)viewSetBgColor:(UIColor *)color img:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)titleColor forStatus:(BOOL)selected
{
    if (selected) {
        NSArray *arr = [NSArray arrayWithObjects:color,imgName,title,titleColor, nil];
        [statusDic setValue:arr forKey:@"selected"];
    }
    else
    {
        NSArray *arr = [NSArray arrayWithObjects:color,imgName,title,titleColor, nil];
        [statusDic setValue:arr forKey:@"unselected"];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    NSArray *arr;
    if (isSelected) {
        arr = [statusDic objectForKey:@"selected"];
    }
    else
    {
        arr = [statusDic objectForKey:@"unselected"];
    }
    [self setStatus:arr];
    
    _isSelected = isSelected;
}

-(void)setStatus:(NSArray *)arr
{
    if (arr&&arr.count) {
        self.backgroundColor = arr[0];
        topImageV.image = [UIImage imageNamed:arr[1]];
        bottomLabel.text = arr[2];
        bottomLabel.textColor = arr[3];
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

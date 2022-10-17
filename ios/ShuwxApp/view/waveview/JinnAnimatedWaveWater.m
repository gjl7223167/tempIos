/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnAnimatedWaveWater.m
 **  Description: 上升效果的水波纹
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "JinnAnimatedWaveWater.h"
#import "JinnWaveWater.h"
#import "Masonry.h"

#define ANIMATION_DURATION 1.f

@interface JinnAnimatedWaveWater ()

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, strong) JinnWaveWater *waveWater;

@end

@implementation JinnAnimatedWaveWater

/**
 初始化
 
 @param sideLength 宽度
 @param backgroundColor 背景色
 @param waveColor 水波纹颜色
 @return 视图
 */
- (instancetype)initWithSideLength:(CGFloat)sideLength
                   backgroundColor:(UIColor *)backgroundColor
                         waveColor:(UIColor *)waveColor
{
    self= [super init];
    
    if (self)
    {
        [self setSideLength:sideLength];
        [self setBackgroundColor:backgroundColor];
        [self setWaveColor:waveColor];
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.sideLength / 2;
    
    JinnWaveWater *waveWater = [[JinnWaveWater alloc] initWithSideLength:self.sideLength
                                                         backgroundColor:self.backgroundColor
                                                               waveColor:self.waveColor];
    [self addSubview:waveWater];
    [self setWaveWater:waveWater];
    [waveWater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.sideLength, self.sideLength));
    }];
}

#pragma mark - Public

/**
 设置水波纹进度百分比
 
 @param percent 百分比
 */
- (void)setPercent:(CGFloat)percent
{
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.waveWater setTransform:CGAffineTransformMakeTranslation(0, - self.sideLength * percent / 100)];
                     } completion:nil];
}

@end

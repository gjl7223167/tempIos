/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnWaveWater.m
 **  Description: 水波纹
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "JinnWaveWater.h"
#import "JinnWave.h"
#import "Pop.h"
#import "Masonry.h"

@interface JinnWaveWater ()

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, strong) JinnWave *wave;

@end

@implementation JinnWaveWater

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
        [self waveWaterAnimation];
    }
    
    return self;
}

- (void)createViews
{
    JinnWave *wave = [[JinnWave alloc] init];
    [wave setBackgroundColor:self.backgroundColor];
    [wave setWaveColor:self.waveColor];
    [self addSubview:wave];
    [self setWave:wave];
    [wave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(- self.sideLength / 2);
        make.centerX.equalTo(self).offset(- self.sideLength / 2);
        make.size.mas_equalTo(CGSizeMake(self.sideLength * 2, self.sideLength * 2));
    }];
}

#pragma mark - Private

/**
 水波纹动画效果
 */
- (void)waveWaterAnimation
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    [animation setDuration:1];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setToValue:@(self.sideLength)];
    [animation setRoundingFactor:0];
    [animation setClampMode:kPOPAnimationClampNone];
    [animation setAdditive:NO];
    [animation setBeginTime:CACurrentMediaTime() + 0];
    [animation setDelegate:self];
    [animation setRemovedOnCompletion:YES];
    [animation setPaused:YES];
    [animation setRepeatCount:MAXFLOAT];
    [animation setRepeatForever:YES];
    [self.wave.layer pop_addAnimation:animation forKey:@"waveAnimation"];
}

@end

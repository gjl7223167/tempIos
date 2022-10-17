//
//  JinnWaveViewTwo.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/23.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "JinnWaveViewTwo.h"
#import "JinnAnimatedWaveWater.h"
#import "JinnWave.h"
#import "Masonry.h"
#import "pop.h"
#import "UICountingLabel.h"

@interface JinnWaveViewTwo ()

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, strong) UIImageView *rotationView;
@property (nonatomic, strong) UILabel *blankLabel;
@property (nonatomic, strong) UICountingLabel *countingLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) JinnAnimatedWaveWater *animatedWaveWater;

@property (nonatomic, strong) JinnWave *wave1;
@property (nonatomic, strong) JinnWave *wave2;

@end

@implementation JinnWaveViewTwo

#pragma mark - 水波纹进度球

- (instancetype)initWithSideLength:(CGFloat)sideLength
{
    self = [super init];
    
    if (self)
    {
        [self setSideLength:sideLength];
        //        [self createCircleViews];
    }
    
    return self;
}

- (void)createCircleViews
{
    self.clipsToBounds = YES;
    
    UIImageView *rotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JinnWaveView.bundle/rotation.png"]];
    [self addSubview:rotationView];
    [self setRotationView:rotationView];
    [rotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self rotationAnimation];
}

/**
 显示没有水波纹的球形视图
 
 @param title 标题
 @param titleColor 描述信息
 @param backgroundColor 背景色
 */
- (void)showBlankViewWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
               backgroundColor:(UIColor *)backgroundColor
{
    [self removeSubviews];
    
    UILabel *blankLabel = [[UILabel alloc] init];
    [blankLabel setBackgroundColor:backgroundColor];
    [blankLabel setFont:[UIFont systemFontOfSize:10]];
    [blankLabel setText:title];
    [blankLabel setTextColor:titleColor];
    [blankLabel setTextAlignment:NSTextAlignmentCenter];
    [blankLabel setClipsToBounds:YES];
    [blankLabel.layer setCornerRadius:self.sideLength * 0.45];
    [self addSubview:blankLabel];
    [self setBlankLabel:blankLabel];
    [blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.sideLength * 0.9, self.sideLength * 0.9));
    }];
}

/**
 显示带有水波纹的球形视图
 
 @param percent 水波纹百分比
 @param description 描述信息
 @param textColor 内容
 @param backgroundColor 背景色
 @param waveColor 水波纹颜色
 */
- (void)showWaveWaterWithPercent:(CGFloat)percent
                     description:(NSString *)description
                       textColor:(UIColor *)textColor
                 backgroundColor:(UIColor *)backgroundColor
                       waveColor:(UIColor *)waveColor
{
    [self removeSubviews];
    
    JinnAnimatedWaveWater *animatedWaveWater = [[JinnAnimatedWaveWater alloc] initWithSideLength:self.sideLength * 0.88 backgroundColor:backgroundColor waveColor:waveColor];
    [self addSubview:animatedWaveWater];
    [self setAnimatedWaveWater:animatedWaveWater];
    [animatedWaveWater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.sideLength * 0.88, self.sideLength * 0.88));
    }];
    
    UICountingLabel* countingLabel = [[UICountingLabel alloc] init];
    [countingLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [countingLabel setTextColor:textColor];
    [countingLabel setTextAlignment:NSTextAlignmentCenter];
    [countingLabel setMethod:UILabelCountingMethodEaseOut];
    [self addSubview:countingLabel];
    [self setCountingLabel:countingLabel];
    [countingLabel setFormat:@"%.f%%"];
    [countingLabel countFrom:0 to:percent];
    [countingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setFont:[UIFont systemFontOfSize:13]];
    [descriptionLabel setText:description];
    [descriptionLabel setTextColor:textColor];
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:descriptionLabel];
    [self setDescriptionLabel:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [animatedWaveWater setPercent:percent];
}

#pragma mark - 纯水波纹背景

- (instancetype)initWithSideLength:(CGFloat)sideLength
                   backgroundColor:(UIColor *)backgroundColor
                         waveColor:(UIColor *)waveColor
{
    self = [super init];
    
    if (self)
    {
        [self setSideLength:sideLength];
        [self setBackgroundColor:backgroundColor];
        [self setWaveColor:waveColor];
        [self createWateWaveViews];
        [self waveWaterAnimation];
    }
    
    return self;
}

- (void)createWateWaveViews
{
    self.clipsToBounds = YES;
    
    JinnWave *wave1 = [[JinnWave alloc] init];
    [wave1 setBackgroundColor:self.backgroundColor];
    [wave1 setWaveColor:self.waveColor];
    [self addSubview:wave1];
    [self setWave1:wave1];
    [wave1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-self.sideLength);
        make.size.mas_equalTo(CGSizeMake(self.sideLength, self.sideLength));
    }];
    
    JinnWave *wave2 = [[JinnWave alloc] init];
    [wave2 setBackgroundColor:self.backgroundColor];
    [wave2 setWaveColor:self.waveColor];
    [self addSubview:wave2];
    [self setWave2:wave2];
    [wave2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.sideLength, self.sideLength));
    }];
}

#pragma mark - Private

- (void)rotationAnimation
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    [animation setDuration:1.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setToValue:[NSNumber numberWithDouble:(M_PI * 2)]];
    [animation setRoundingFactor:0];
    [animation setClampMode:kPOPAnimationClampNone];
    [animation setAdditive:NO];
    [animation setBeginTime:CACurrentMediaTime() + 0];
    [animation setDelegate:self];
    [animation setRemovedOnCompletion:YES];
    [animation setPaused:YES];
    [animation setRepeatCount:MAXFLOAT];
    [animation setRepeatForever:YES];
    [self.rotationView.layer pop_addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)waveWaterAnimation
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    [animation setDuration:1.5];
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
    [self.wave1.layer pop_addAnimation:animation forKey:@"wave1Animation"];
    [self.wave2.layer pop_addAnimation:animation forKey:@"wave2Animation"];
}

- (void)removeSubviews
{
    if (self.blankLabel != nil)
    {
        [self.blankLabel removeFromSuperview];
    }
    
    if (self.countingLabel != nil)
    {
        [self.countingLabel removeFromSuperview];
    }
    
    if (self.descriptionLabel != nil)
    {
        [self.descriptionLabel removeFromSuperview];
    }
    
    if (self.animatedWaveWater != nil)
    {
        [self.animatedWaveWater removeFromSuperview];
    }
    
    if (self.wave1 != nil)
    {
        [self.wave1 removeFromSuperview];
    }
    
    if (self.wave2 != nil)
    {
        [self.wave2 removeFromSuperview];
    }
}

@end

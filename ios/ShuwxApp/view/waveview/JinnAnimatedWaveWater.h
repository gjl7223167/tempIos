/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnAnimatedWaveWater.h
 **  Description: 上升效果的水波纹
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import <UIKit/UIKit.h>

@interface JinnAnimatedWaveWater : UIView

/**
 初始化

 @param sideLength 宽度
 @param backgroundColor 背景色
 @param waveColor 水波纹颜色
 @return 视图
 */
- (instancetype)initWithSideLength:(CGFloat)sideLength
                   backgroundColor:(UIColor *)backgroundColor
                         waveColor:(UIColor *)waveColor;

/**
 设置水波纹进度百分比

 @param percent 百分比
 */
- (void)setPercent:(CGFloat)percent;

@end

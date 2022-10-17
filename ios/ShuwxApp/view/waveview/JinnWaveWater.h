/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnWaveWater.h
 **  Description: 水波纹
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import <UIKit/UIKit.h>

@interface JinnWaveWater : UIView

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

@end

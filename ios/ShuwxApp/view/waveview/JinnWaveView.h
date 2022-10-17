/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnWaveView.h
 **  Description: 水波纹球形视图
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import <UIKit/UIKit.h>

@interface JinnWaveView : UIView

#pragma mark - 水波纹进度球

- (instancetype)initWithSideLength:(CGFloat)sideLength;

/**
 显示没有水波纹的球形视图

 @param title 标题
 @param titleColor 描述信息
 @param backgroundColor 背景色
 */
- (void)showBlankViewWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
               backgroundColor:(UIColor *)backgroundColor;

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
                       waveColor:(UIColor *)waveColor;

#pragma mark - 纯水波纹背景

- (instancetype)initWithSideLength:(CGFloat)sideLength
                   backgroundColor:(UIColor *)backgroundColor
                         waveColor:(UIColor *)waveColor;

@end

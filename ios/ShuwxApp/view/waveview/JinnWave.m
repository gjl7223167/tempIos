/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnWave.m
 **  Description: 波纹单元
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "JinnWave.h"
#import "UIColor+JinnWaveView.h"

#define kSideLength CGRectGetHeight(self.bounds)

@implementation JinnWave

- (void)drawRect:(CGRect)rect
{
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextAddRect(context1, self.bounds);
    [self.backgroundColor set];
    CGContextFillPath(context1);
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context2, 0, kSideLength * 0.5);
    CGContextAddCurveToPoint(context2,
                             kSideLength * (2.0/8.0),
                             kSideLength * (3.5/6.0),
                             kSideLength * (2.0/8.0),
                             kSideLength * (2.5/6.0),
                             kSideLength * (4.0/8.0),
                             kSideLength * (4.0/8.0));
    CGContextAddCurveToPoint(context2,
                             kSideLength * (6.0/8.0),
                             kSideLength * (3.5/6.0),
                             kSideLength * (6.0/8.0),
                             kSideLength * (2.5/6.0),
                             kSideLength * (8.0/8.0),
                             kSideLength * (4.0/8.0));
    CGContextAddLineToPoint(context2, kSideLength, kSideLength);
    CGContextAddLineToPoint(context2, 0, kSideLength);
    CGContextAddLineToPoint(context2, 0, kSideLength * 0.5);
    [[UIColor colorWithRed:self.waveColor.red green:self.waveColor.green blue:self.waveColor.blue alpha:0.5] setFill];
    CGContextFillPath(context2);
    
    CGContextRef context3 = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context3, 0, kSideLength * 0.5);
    CGContextAddCurveToPoint(context3,
                             kSideLength * (2.0/8.0),
                             kSideLength * (3.2/6.0),
                             kSideLength * (2.0/8.0),
                             kSideLength * (2.5/6.0),
                             kSideLength * (4.0/8.0),
                             kSideLength * (4.0/8.0));
    CGContextAddCurveToPoint(context3,
                             kSideLength * (6.0/8.0),
                             kSideLength * (3.2/6.0),
                             kSideLength * (6.0/8.0),
                             kSideLength * (2.5/6.0),
                             kSideLength * (8.0/8.0),
                             kSideLength * (4.0/8.0));
    CGContextAddLineToPoint(context3, kSideLength, kSideLength);
    CGContextAddLineToPoint(context3, 0, kSideLength);
    CGContextAddLineToPoint(context3, 0, kSideLength * 0.5);
    [[UIColor colorWithRed:self.waveColor.red green:self.waveColor.green blue:self.waveColor.blue alpha:0.2] setFill];
    CGContextFillPath(context3);
    
    CGContextRef context4 = UIGraphicsGetCurrentContext();
    CGContextAddRect(context4, CGRectMake(0, kSideLength, kSideLength, kSideLength));
    [self.waveColor set];
    CGContextFillPath(context4);
}

@end

/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: UIColor+JinnWaveView.m
 **  Description: 
 **
 **  Author: jinnchang
 **  Date: 16/6/24
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "UIColor+JinnWaveView.h"

@implementation UIColor (JinnWaveView)

#pragma mark - Public

- (CGFloat)red
{
    return CGColorGetComponents(self.CGColor)[0];
}

- (CGFloat)green
{
    return ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) ?
    CGColorGetComponents(self.CGColor)[0] : CGColorGetComponents(self.CGColor)[1];
}

- (CGFloat)blue
{
    return ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) ?
    CGColorGetComponents(self.CGColor)[0] : CGColorGetComponents(self.CGColor)[2];
}

- (CGFloat)alpha
{
    return CGColorGetComponents(self.CGColor)[CGColorGetNumberOfComponents(self.CGColor) - 1];
}

#pragma mark - Private

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

@end

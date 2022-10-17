//
//  UIImage+LBDownSampling.h
//  LBCommonComponentsExample
//
//  Created by 刘彬 on 2021/3/26.
//  Copyright © 2021 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LBDownSampling)
/// 压缩图片
/// @param pointSize 改变图片到目标大小
/// @param scale 压缩比
- (UIImage *)lb_downSamplingToPointSize:(CGSize)pointSize
                                  scale:(CGFloat)scale;
@end

NS_ASSUME_NONNULL_END

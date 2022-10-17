//
//  UIViewController+LBNavigationBarAppearance.h
//
//  Created by 刘彬 on 2020/10/14.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LBNavigationBarAppearanceStyle) {
    LBNavigationBarDefault = 0,//系统
    LBNavigationBarTransparent,//透明，
    LBNavigationBarTransparentShadowLine,//透明，有分割线
    LBNavigationBarHidden//隐藏
};
@interface UIViewController (LBNavigationBarAppearance)
/// 只有在UINavigationBar的lb_appearanceAvailable为YES的情况下以下设置才有效
/// @param style 透明风格
/// @param color tintColor
-(void)setNavigationBarAppearanceStyle:(LBNavigationBarAppearanceStyle)style tintColor:(nullable UIColor *)color;
@end

@interface UINavigationBar (LBAppearance)
@property (nonatomic, assign) BOOL lb_appearanceAvailable;//default NO
@property (nonatomic, copy  ) NSString *lb_backItemTitle;
@end

NS_ASSUME_NONNULL_END

//
//  anLightView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface anLightView : UIView

@property(nonatomic ,assign)BOOL isSelected;
-(void)viewAddTaget:(id)taget sel:(SEL)sel;
-(void)viewSetBgColor:(UIColor *)color img:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)titleColor forStatus:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END

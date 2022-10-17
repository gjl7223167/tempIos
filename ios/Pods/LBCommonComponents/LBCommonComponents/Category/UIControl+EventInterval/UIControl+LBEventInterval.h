//
//  UIControl+LBEventInterval.h
//  Site
//
//  Created by 刘彬 on 2020/9/4.
//  Copyright © 2020 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (LBEventInterval)
@property (nonatomic, assign) NSTimeInterval lb_eventInterval;
@property (nonatomic, assign) BOOL lb_eventUnavailable;
@end

NS_ASSUME_NONNULL_END

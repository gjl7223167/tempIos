//
//  noNetWorkView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^reloadBlock) ();

@interface noNetWorkView : UIView

@property(nonatomic,copy) reloadBlock reloadB;


@end

NS_ASSUME_NONNULL_END

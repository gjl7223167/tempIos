//
//  RemarksView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/29.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+YLTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemarksView : UIView<UITextViewDelegate>

@property(nonatomic ,strong)UITextView *contentTV;
@end

NS_ASSUME_NONNULL_END

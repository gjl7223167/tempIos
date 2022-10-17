//
//  scanInputView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NSTransferBlock) (NSString *_Nullable);
NS_ASSUME_NONNULL_BEGIN

@interface scanInputView : UIView

@property(nonatomic ,strong) UITextField *contentTF;
@property(nonatomic,copy)NSTransferBlock InputContentB;

@end

NS_ASSUME_NONNULL_END

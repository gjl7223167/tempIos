//
//  WorkTaskViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/2.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NotifyBlock) (NSInteger);

@interface WorkTaskViewController : BaseViewController

@property (nonatomic,assign) BOOL isDetail;//详情/报工
@property(nonatomic ,copy) NSString *workOrderId;

@property(nonatomic ,copy)NotifyBlock notifyB;

@end

NS_ASSUME_NONNULL_END

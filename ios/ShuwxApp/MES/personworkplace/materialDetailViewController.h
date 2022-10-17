//
//  materialDetailViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/16.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface materialDetailViewController : BaseViewController

@property(nonatomic ,copy) NSString *workOrderId;
@property (nonatomic,assign) BOOL isDetail;//详情/报工

@end

NS_ASSUME_NONNULL_END

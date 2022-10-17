//
//  StoreRequireInfomationViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/19.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreRequireInfomationViewController : BaseViewController

@property(nonatomic ,copy) NSString *workOrderId;

@property (nonatomic,assign) BOOL isInStore;

@property (nonatomic,strong)NSString *status;

@end

NS_ASSUME_NONNULL_END

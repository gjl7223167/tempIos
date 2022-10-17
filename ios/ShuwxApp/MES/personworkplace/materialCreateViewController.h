//
//  materialCreateViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/17.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface materialCreateViewController : BaseViewController

@property(nonatomic ,copy) NSString *workOrderId;

@property(nonatomic ,strong)NSDictionary *materialDic;

@end

NS_ASSUME_NONNULL_END

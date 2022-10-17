//
//  OperatorListViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/5.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NSOperatorBlock) (NSArray *operatorArr);

@interface OperatorListViewController : BaseViewController

@property(nonatomic,copy) NSOperatorBlock OperatorB;

@property (nonatomic ,strong) NSArray *selectedOperatorArr;

@end

NS_ASSUME_NONNULL_END

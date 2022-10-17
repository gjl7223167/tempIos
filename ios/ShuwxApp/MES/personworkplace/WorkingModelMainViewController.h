//
//  WorkingModelMainViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkingModelMainViewController : BaseViewController

@property (nonatomic,strong) NSDictionary *workDic;

@property (nonatomic,strong) NSArray *allTitleArr;

@property (strong, nonatomic) NSMutableArray *propertyArr;

@end

NS_ASSUME_NONNULL_END

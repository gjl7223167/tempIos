//
//  ModelWorkTaskViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/11.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NotifyBlock) (NSInteger);
@interface ModelWorkTaskViewController : BaseViewController

@property (nonatomic,assign) BOOL isDetail;//详情/报工
@property(nonatomic ,copy) NSString *workOrderId;

@property(nonatomic ,copy)NotifyBlock notifyB;

@property (strong, nonatomic) NSMutableArray *propertyArr;//模型数组

@property (nonatomic,strong) NSArray *allTitleArr;

@end

NS_ASSUME_NONNULL_END

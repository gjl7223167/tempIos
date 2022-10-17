//
//  QualityRecordModelViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/16.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QualityRecordModelViewController : BaseViewController

@property (nonatomic,assign) BOOL isDetail;//详情/记录

@property(nonatomic,copy)NSString *myId;

@property (strong, nonatomic) NSMutableArray *propertyArr;//模型数组
@property (nonatomic,strong) NSArray *titleArr;


@end

NS_ASSUME_NONNULL_END

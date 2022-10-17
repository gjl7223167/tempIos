//
//  UnqualityDetailViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/1.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnqualityDetailViewController : BaseViewController

@property(nonatomic ,assign) BOOL isDetail;

@property(nonatomic,strong)NSDictionary *unqualityDic;
@property (nonatomic,strong) NSArray *titleArr;

@end

NS_ASSUME_NONNULL_END

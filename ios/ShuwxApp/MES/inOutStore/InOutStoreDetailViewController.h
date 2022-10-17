//
//  InOutStoreDetailViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/9.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InOutStoreDetailViewController : BaseViewController

@property(nonatomic ,assign)BOOL  isInStoreRoom;
@property(nonatomic ,strong)NSString *workOrderId;
@property(nonatomic ,strong)NSString *code;

@property(nonatomic ,strong)NSDictionary *__nullable dataDic;

@end

NS_ASSUME_NONNULL_END

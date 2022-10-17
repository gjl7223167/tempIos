//
//  SupplierChooseViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupplierChooseViewController : BaseViewController

@property(nonatomic ,assign)int type;
@property(nonatomic ,strong)NSString *materialId;

@property(nonatomic ,copy)NSSearchBackBlock SupplierBack;

@end

NS_ASSUME_NONNULL_END

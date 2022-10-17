//
//  StorePositionChooseViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/3.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StorePositionChooseViewController : BaseViewController

@property(nonatomic ,strong)NSString *materialId;

@property(nonatomic ,copy)NSSearchBackBlock PositionBack;

@end

NS_ASSUME_NONNULL_END

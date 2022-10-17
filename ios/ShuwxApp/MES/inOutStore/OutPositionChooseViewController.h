//
//  OutPositionChooseViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/8.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutPositionChooseViewController : BaseViewController

@property(nonatomic ,copy)NSSearchBackBlock OutPositionBack;

@property(nonatomic ,strong)NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END

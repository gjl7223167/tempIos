//
//  AddDefectInfoViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/25.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddDefectInfoViewController : BaseViewController

@property(nonatomic,strong)NSDictionary *defectDic;
@property(nonatomic,copy)NSString *myId;

@property(nonatomic,assign) BOOL isAdd;

@end

NS_ASSUME_NONNULL_END

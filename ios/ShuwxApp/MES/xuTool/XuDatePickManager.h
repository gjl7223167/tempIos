//
//  XuDatePickManager.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "PGDatePickManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NSDatePickerBlock) (NSString *);
@interface XuDatePickManager : PGDatePickManager

@property(nonatomic ,copy)NSDatePickerBlock DatePickerB;

@end

NS_ASSUME_NONNULL_END

//
//  WorkOperatorModel.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkOperatorModel : NSObject

@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *myid;

@property(nonatomic,assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END

//
//  AddUnqualityRecordViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/4/7.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddUnqualityRecordViewController : BaseViewController

@property(nonatomic,strong)NSDictionary *recordDic;
@property(nonatomic,copy)NSString *rejectsBillId;
@property (strong, nonatomic) NSArray *reasonArr;
@property (strong, nonatomic) NSArray *suggestArr;

@property(nonatomic,assign) BOOL isAdd;

@end

NS_ASSUME_NONNULL_END

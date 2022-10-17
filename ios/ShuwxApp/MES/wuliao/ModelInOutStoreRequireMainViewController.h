//
//  ModelInOutStoreRequireMainViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/18.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModelInOutStoreRequireMainViewController : BaseViewController

@property (nonatomic,strong) NSDictionary *titleDic;
@property (nonatomic,assign) BOOL isInStore;

-(void)updateStoreData;

@end

NS_ASSUME_NONNULL_END

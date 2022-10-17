//
//  EditMaterialInfoViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^backBlock)(NSDictionary * _Nonnull dic);
NS_ASSUME_NONNULL_BEGIN

@interface EditMaterialInfoViewController : BaseViewController

@property(nonatomic ,assign)BOOL  isInStoreRoom;
@property(nonatomic ,copy)backBlock materialInfoB;

@property(nonatomic ,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

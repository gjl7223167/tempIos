//
//  BottomListShowView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"

typedef enum : NSUInteger {
    bottomApplyOutStoreInfo = 1,
    bottomInOutCreateStore,
    bottomAddDefectInfo,
    bottomAddUnqualityRecord,
}bottomListShowEnum;

typedef void(^NSRecieverBackBlock) (NSDictionary * _Nullable dic);

NS_ASSUME_NONNULL_BEGIN

@interface BottomListShowView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) bottomListShowEnum showFrom;

@property (strong, nonatomic) BaseTableView *myTableView;

@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic ,copy)NSRecieverBackBlock StoreLocationBack;

@end

NS_ASSUME_NONNULL_END

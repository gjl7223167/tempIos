//
//  MESScanViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LBXScanViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    scanWorkingProcedureMain = 1,
    scanMaterialDetail,
    scanStoreDetailRequire,
    scanApplyInStoreInfo,
    scanApplyOutStoreInfo,
    scanInOutCreateStore,
    scanInOutCreateStoreOut,
    scanQualityInspectionPlanManage,
    scanUnqualityHandleMain,
}scanTypeEnum;

typedef void(^NSScanBackBlock) (id);

@interface MESScanViewController : LBXScanViewController

@property(nonatomic ,assign) scanTypeEnum scanType;
@property(nonatomic ,copy) NSScanBackBlock ScanBackB;

@property (nonatomic ,copy) NSString *myId;
@property (nonatomic ,strong) NSDictionary *myDic;

@property(nonatomic,strong)NSArray *titleArr;

@end

NS_ASSUME_NONNULL_END

//
//  SearchViewController.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/5.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NSSearchBackBlock) (id __nullable dic);


typedef enum : NSUInteger {
    searchWorkingProcedureMain = 1,
    searchWorkingProcedureMainDetail,
    searchMaterialCreate,
    searchOperatorList,
    searchModelInOutStoreRequireMain,
    searchModelInOutStoreRequireMainDetail,
    searchStorePositionChoose,
    searchSupplierChoose,
    searchMaterialReceiver,
    searchStoreRoomManager,
    searchStoreRoomManagerDetail,
    searchOutPositionChoose,
    searchQualityInspectionPlanManage,
    searchQualityInspectionPlanManageDetail,
    searchUnqualityHandleMain,
    searchUnqualityHandleMainDetail,
}searchTypeEnum;

@interface SearchViewController : BaseViewController

@property(nonatomic ,assign) searchTypeEnum searchFrom;
@property(nonatomic ,strong) NSDictionary *paramDic;

@property(nonatomic ,copy) NSSearchBackBlock SearchBackB;

@property(nonatomic ,strong) NSString *paramStr;
@property(nonatomic ,strong) NSString *paramSubStr;

@property (nonatomic,assign) BOOL isInStore;
@property (strong, nonatomic) NSMutableArray *propertyArr;

@end

NS_ASSUME_NONNULL_END

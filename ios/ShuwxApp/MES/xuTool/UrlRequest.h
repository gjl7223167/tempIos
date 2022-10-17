//
//  UrlRequest.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/1.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UrlRequest : NSObject


/**
 * 获取各种情况类型
 */
+(void)requestSelectDictionaryByTypeWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
 * 工序工单列表查询
 */
+(void)requestworkbenchappWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 查询工序工单详情
 */
+(void)requestworkDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 开工
 */
+(void)requestStartWorkWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 暂停/恢复工单
 */
+(void)requestStopAndResumeWorkWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 创建报工
 */
+(void)requestWorkCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 创建上料
 */
+(void)requestMaterialCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 工序工单扫码
 */
+(void)requestWorkScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 上料扫码
 */
+(void)requestMaterialDetailScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 查询上料物料列表
 */
+(void)requestMaterialNameListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 操作人员列表
 */
+(void)requestMaterialOperatorListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 搜索工序工单
 */
+(void)requestSearchWorkBenchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 设备异常安灯
 */
+(void)requestDeviceAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 缺料异常安灯
 */
+(void)requestMaterialAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 质量异常安灯
 */
+(void)requestQualityAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

#pragma mark -- 出入库需求

/**
* 需求单入库app分页
*/
+(void)requestRequireInStoreListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 需求单出库app分页
*/
+(void)requestRequireOutStoreListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 需求单出入库首页搜索
*/
+(void)requestRequireInOutStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;


/**
* 需求单子级详情
*/
+(void)requestRequireStoreDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;


/**
*  提交填写入库需求信息
*/
+(void)requestSubmitInStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;


/**
*  入库推荐供应商
*/
+(void)requestRecommendSupplierWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  查询所有人员（收料人）
*/
+(void)requestMaterialRecieverWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  出库需求保存
*/
+(void)requestOutStoreRequireSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  保存入库单
*/
+(void)requestInStoreSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  保存出库单
*/
+(void)requestOutStoreSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  入库搜索
*/
+(void)requestInStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  出库搜索
*/
+(void)requestOutStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  入库主界面列表数据
*/
+(void)requestInStoreMainListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  出库主界面列表数据
*/
+(void)requestOutStoreMainListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  入库详情子集数据
*/
+(void)requestInStoreDetailListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  出库详情子集数据
*/
+(void)requestOutStoreDetailListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  质检计划管理搜索
*/
+(void)requestQualityInspectionSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  质检计划管理分页列表
*/
+(void)requestQualityInspectionListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  质检计划管理扫码
*/
+(void)requestQualityInspectionScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  质检记录保存
*/
+(void)requestQualityInspectionSaveWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  创建不合格品处理单
*/
+(void)requestUnqualityHandleCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  修改检验项
*/
+(void)requestModifyInspectionInfoWithParam:(NSArray *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  保存单件产品检验信息
*/
+(void)requestSaveSingleInspectionInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  新增/修改缺陷信息
*/
+(void)requestAddDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  不良品处理单分页列表
*/
+(void)requestUnqualityHandleListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  不良品处理单管理扫码
*/
+(void)requestUnqualityScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  不良品处理单管理搜索
*/
+(void)requestUnqualitySearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  不良品处理执行完毕
*/
+(void)requestUnqualityHandleEndWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  保存不良品原因
*/
+(void)requestSaveUnqualityReasonWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;











//以下为GET请求
/**
* 查询报工记录
*/
+(void)requestWorkListDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 查询上料记录
*/
+(void)requestMaterialListDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 需求单父级详情
*/
+(void)requestRequireStoreInfomationWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 填写入库需求信息
*/
+(void)requestInStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
* 填写出库需求信息
*/
+(void)requestOutStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
* 需求单入库查询库房分类
*/
+(void)requestStoreRequireLeftWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 需求单入库查询库房具体位置信息
*/
+(void)requestStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 搜索需求单入库查询库房具体位置信息
*/
+(void)requestSearchStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
* 需求单入库查询推荐库房具体位置信息
*/
+(void)requestRecommendStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 供应商/厂商下拉列表
*/
+(void)requestSupplierListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
* 出入库需求详情页扫码
*/
+(void)requestInOutRequireScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;
/**
*  填写入库需求界面扫码库房
*/
+(void)requestInStoreRequireScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  填写出库需求界面扫码库位
*/
+(void)requestOutStoreRequireLocationScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  填写出库需求界面查询库位
*/
+(void)requestOutStoreRequireLocationSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   填写入库页面扫码
*/
+(void)requestMaterialScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   填写出库页面扫码
*/
+(void)requestOutMaterialScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   出库推荐位置
*/
+(void)requestOutRecommendPositionWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   出库位置信息
*/
+(void)requestOutStorePositionWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   检验记录界面数据
*/
+(void)requestQualityRecordWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   点击检验记录列表,检验项信息
*/
+(void)requestInspectionItemInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*   获取单件产品检验信息
*/
+(void)requestSingleProductInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  获取缺陷信息界面数据
*/
+(void)requestDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  删除缺陷信息
*/
+(void)requestDeleteDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  获取缺陷项
*/
+(void)requestDefectTypeWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  获取不良品处理单主界面状态
*/
+(void)requestUnqualityHandleStatusWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  删除不良品单
*/
+(void)requestDeleteUnqualityWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  删除不良原因
*/
+(void)requestDeleteUnqualityReasonWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
*  获取不良原因列表
*/
+(void)requestUnqualityReasonListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

@end

NS_ASSUME_NONNULL_END

//
//  UrlRequest.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/1.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "UrlRequest.h"
#import "NetworkManager.h"

@implementation UrlRequest


#pragma mark -- 工序工单
+(void)requestSelectDictionaryByTypeWithParam:(NSDictionary *)params completion:(void (^)(BOOL result, id data, NSString * error))block{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *company_id = [defaults objectForKey:@"company_id"];
    
//    
    NSString *url = [NSString stringWithFormat:@"/bcs/universal/dictionary/selectDictionaryByType?dic_type=%@&company_id=%@",params[@"dic_type"],company_id];
    [[NetworkManager sharedManager] PostWithUrl:url params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}



+(void)requestworkbenchappWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 查询工序工单详情
 */
+(void)requestworkDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *orderid = params[@"workOrderId"];
    NSString *url = [NSString stringWithFormat:@"/mes_production/work-bench-app/%@",orderid];
    [[NetworkManager sharedManager] PostWithUrl:url params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}


/**
 * 开工
 */
+(void)requestStartWorkWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *orderid = params[@"workOrderId"];
    NSString *url = [NSString stringWithFormat:@"/mes_production/work-bench-app/start-work/%@",orderid];
    [[NetworkManager sharedManager] PostWithUrl:url params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 暂停/恢复工单
 */
+(void)requestStopAndResumeWorkWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    //type 1:暂停，2: 恢复
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/recoverWork" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 创建报工
 */
+(void)requestWorkCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/report" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 创建上料
 */
+(void)requestMaterialCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/materialConsume" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 工序工单扫码
 */
+(void)requestWorkScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/workOrder/scanCode" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 上料扫码
 */
+(void)requestMaterialDetailScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/materialConsume/scanCode" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 查询上料物料列表
 */
+(void)requestMaterialNameListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/workbench/findMaterialConsumeList" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 操作人员列表
 */
+(void)requestMaterialOperatorListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_lak/staff/list" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 搜索工序工单
 */
+(void)requestSearchWorkBenchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block{
    
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/work-bench-app/code" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 设备异常安灯
 */
+(void)requestDeviceAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/andon/device-abnormal" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 缺料异常安灯
 */
+(void)requestMaterialAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/andon/material-abnormal" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 质量异常安灯
 */
+(void)requestQualityAbnormalWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_production/andon/quality-abnormal" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

#pragma mark -- 出入库需求

/**
* 需求单入库app分页
*/
+(void)requestRequireInStoreListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
* 需求单出库app分页
*/
+(void)requestRequireOutStoreListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandOutApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
* 需求单出入库首页搜索
*/
+(void)requestRequireInOutStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *urlStr = [NSString stringWithFormat:@"/mes_stock/demandOutApp/search?code=%@&type=%@",params[@"code"],params[@"type"]];
    [[NetworkManager sharedManager] PostWithUrl:urlStr params:nil successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}


/**
* 需求单子级详情
*/
+(void)requestRequireStoreDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandOutApp/selectSubsetDemandDetail" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  提交填写入库需求信息
*/
+(void)requestSubmitInStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandApp/saveDemandIn" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  入库推荐供应商
*/
+(void)requestRecommendSupplierWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandApp/recommendSupplier" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  查询所有人员（收料人）
*/
+(void)requestMaterialRecieverWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/checkbill/queryUser" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  出库需求保存
*/
+(void)requestOutStoreRequireSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/demandOutApp/saveOutbound" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  保存入库单
*/
+(void)requestInStoreSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/inboundbillApp/saveInboundBill" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  保存出库单
*/
+(void)requestOutStoreSubmitWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/outboundbillApp/saveOutboundBill" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  入库搜索
*/
+(void)requestInStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/inboundbillApp/search" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
*  出库搜索
*/
+(void)requestOutStoreSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/outboundbillApp/search" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  入库主界面列表数据
*/
+(void)requestInStoreMainListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/inboundbillApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
*  出库主界面列表数据
*/
+(void)requestOutStoreMainListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/outboundbillApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  入库详情子集数据
*/
+(void)requestInStoreDetailListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/inboundbillApp/selectSubsetDemandDetail" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
*  出库详情子集数据
*/
+(void)requestOutStoreDetailListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_stock/outboundbillApp/pageDetail" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  质检计划管理搜索
*/
+(void)requestQualityInspectionSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/search" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  质检计划管理分页列表
*/
+(void)requestQualityInspectionListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
*  质检计划管理扫码
*/
+(void)requestQualityInspectionScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/scanCode" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  质检记录保存
*/
+(void)requestQualityInspectionSaveWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/saveQualityDetail" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  创建不合格品处理单
*/
+(void)requestUnqualityHandleCreateWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/saveRejectsBill" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  修改检验项
*/
+(void)requestModifyInspectionInfoWithParam:(NSArray *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/updateInspection" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}
/**
*  保存单件产品检验信息
*/
+(void)requestSaveSingleInspectionInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/saveSingleton" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  新增/修改缺陷信息
*/
+(void)requestAddDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/qualityApp/updateDefect" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  不良品处理单分页列表
*/
+(void)requestUnqualityHandleListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/rejectsbillApp/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  不良品处理单管理扫码
*/
+(void)requestUnqualityScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/rejectsbillApp/scanCode" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  不良品处理单管理搜索
*/
+(void)requestUnqualitySearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/rejectsbillApp/search" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];

}

/**
*  不良品处理执行完毕
*/
+(void)requestUnqualityHandleEndWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/rejectsbillApp/saveRejectsResin" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  保存不良品原因
*/
+(void)requestSaveUnqualityReasonWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_quality/rejectsbillApp/saveRejectsReson" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg){
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}




















//GET请求
/**
* 查询报工记录
*/
+(void)requestWorkListDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *orderid = params[@"workOrderId"];
    NSString *url = [NSString stringWithFormat:@"/mes_production/work-bench-app/report/%@",orderid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}


/**
* 查询上料记录
*/
+(void)requestMaterialListDetailWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *orderid = params[@"workOrderId"];
    NSString *url = [NSString stringWithFormat:@"/mes_production/work-bench-app/materialConsume/%@",orderid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 需求单父级详情
*/
+(void)requestRequireStoreInfomationWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandOutApp/selectDemandDetail?id=%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 填写入库需求信息
*/
+(void)requestInStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandApp/findDemandDetail/%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 填写出库需求信息
*/
+(void)requestOutStoreRequireInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandOutApp/selectOutbound?id=%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  填写入库需求界面扫码库房
*/
+(void)requestInStoreRequireScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandApp/scanCode/%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 需求单入库查询库房分类
*/
+(void)requestStoreRequireLeftWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *url = @"/mes_lak/warehouse/app/findWarehouseByType";
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}
/**
* 需求单入库查询库房具体位置信息
*/
+(void)requestStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_lak/warehouse/app/findWareHouseById?id=%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 搜索需求单入库查询库房具体位置信息
*/
+(void)requestSearchStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"name"];
    NSString *url = [NSString stringWithFormat:@"/mes_lak/warehouse/app/seachWarehouse?name=%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 需求单入库查询推荐库房具体位置信息
*/
+(void)requestRecommendStoreRequirePosWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandApp/recommendWarehouse/%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}
/**
* 供应商/厂商下拉列表
*/
+(void)requestSupplierListDataWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *url;
    if (params) {
        NSString *oid = params[@"name"];
        url = [NSString stringWithFormat:@"/mes_lak/supplier/selectSupplier?name=%@",oid];
    }else{
        url = @"/mes_lak/supplier/selectSupplier";
    }
    
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
* 出入库需求详情页扫码
*/
+(void)requestInOutRequireScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"id"];
    NSString *code = params[@"code"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandApp/scanCodeMaterial?id=%@&code=%@",oid,code];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  填写出库需求界面扫码库位
*/
+(void)requestOutStoreRequireLocationScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *batch = params[@"batch"];
    NSString *materialId = params[@"materialId"];
    NSString *positionId = params[@"positionId"];
    NSString *qty = params[@"qty"];

    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandOutApp/scanCodeWarehouse?batch=%@&materialId=%@&positionId=%@&qty=%@",batch,materialId,positionId,qty];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  填写出库需求界面查询库位
*/
+(void)requestOutStoreRequireLocationSearchWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *batch = params[@"batch"];
    NSString *materialId = params[@"materialId"];
    NSString *positionId = params[@"positionId"];
    NSString *oid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_stock/demandOutApp/findWarehouse?batch=%@&materialId=%@&positionId=%@&id=%@",batch,materialId,positionId,oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}


/**
* 填写入库页面扫码
*/
+(void)requestMaterialScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"code"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/inboundbillApp/scanCode/%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   填写出库页面扫码
*/
+(void)requestOutMaterialScanWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *oid = params[@"code"];
    NSString *url = [NSString stringWithFormat:@"/mes_stock/outboundbillApp/scanCode?id=%@",oid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   出库推荐位置
*/
+(void)requestOutRecommendPositionWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *batchNo = params[@"batchNo"];
    NSString *materialId = params[@"materialId"];

    NSString *url = [NSString stringWithFormat:@"/mes_stock/outboundbillApp/recommendedLocation?batchNo=%@&materialId=%@",batchNo,materialId];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   出库位置信息
*/
+(void)requestOutStorePositionWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *batchNo = params[@"batchNo"];
    NSString *materialId = params[@"materialId"];
    NSString *name = params[@"name"];

    NSString *url = [NSString stringWithFormat:@"/mes_stock/outboundbillApp/selectPositionByName?batchNo=%@&materialId=%@&name=%@",batchNo,materialId,name];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   检验记录界面数据
*/
+(void)requestQualityRecordWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_quality/qualityApp/findQuality?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   点击检验记录列表,检验项信息
*/
+(void)requestInspectionItemInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_quality/qualityApp/findInspectionItems?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*   获取单件产品检验信息
*/
+(void)requestSingleProductInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_quality/qualityApp/findSingleton?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  获取缺陷信息界面数据
*/
+(void)requestDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_quality/qualityApp/findDefectInformation?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  删除缺陷信息
*/
+(void)requestDeleteDefectInfoWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];

    NSString *url = [NSString stringWithFormat:@"/mes_quality/qualityApp/deleteDefect?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  获取缺陷项
*/
+(void)requestDefectTypeWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_lak/inspectionsubject/selectSchemeSubjectRela?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  获取不良品处理单主界面状态
*/
+(void)requestUnqualityHandleStatusWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] GetWithUrl:@"/mes_quality/rejectsbillApp/getStatus" successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  删除不良品单
*/
+(void)requestDeleteUnqualityWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_quality/rejectsbillApp/delRejectsBill?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  删除不良原因
*/
+(void)requestDeleteUnqualityReasonWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_quality/rejectsbillApp/deleteRejectsReson?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
*  获取不良原因列表
*/
+(void)requestUnqualityReasonListWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *myid = params[@"id"];
    NSString *url = [NSString stringWithFormat:@"/mes_quality/rejectsbillApp/inquiryReason?id=%@",myid];
    [[NetworkManager sharedManager] GetWithUrl:url successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}


@end

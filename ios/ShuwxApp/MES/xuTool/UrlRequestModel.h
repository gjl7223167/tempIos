//
//  UrlRequestModel.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UrlRequestModel : NSObject


/**
 * 模型样式获取
 */
+(void)requestWorkModelWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;

/**
 * 工序工单状态列表数据
 */
+(void)requestWorkListByTypeWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;


/**
 * 详情模型
 */
+(void)requestDetailModelWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;


/**
 * 关联数据获取
 */
+(void)requestLinkedData:(NSString *)url Param:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block;





@end

NS_ASSUME_NONNULL_END


//
//  UrlRequestModel.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "UrlRequestModel.h"
#import "NetworkManager.h"

@implementation UrlRequestModel


/**
 * 模型样式获取
 */
+(void)requestWorkModelWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    NSString *urlS = SDURLEncodeURLQueryParamters(@"/mes_lak/datamodel/getInfoDetailByCode?", params);
    [[NetworkManager sharedManager] GetWithUrl:urlS successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 工序工单状态列表数据
 */
+(void)requestWorkListByTypeWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_lak/datamodel/object/page" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}

/**
 * 详情模型
 */
+(void)requestDetailModelWithParam:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:@"/mes_lak/datamodel/object/info" params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}


/**
 * 关联数据获取
 */
+(void)requestLinkedData:(NSString *)url Param:(NSDictionary *__nullable)params completion:(void(^)(BOOL result, id data , NSString *error))block
{
    [[NetworkManager sharedManager] PostWithUrl:url params:params successBlock:^(BOOL result, id  _Nullable data, NSString *msg) {
        block(result,data,nil);
    } failureBlock:^(BOOL result, NSString * _Nonnull error) {
        block(result,nil,error);
    }];
}







@end



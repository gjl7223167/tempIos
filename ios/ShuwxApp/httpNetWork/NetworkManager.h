//
//  NetworkManager.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/1.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager

+ (NSString *)URLString;

+ (instancetype)sharedManager;

+ (void)shareManagerDealloc;
- (void)PostWithUrl:(NSString *)url params:(NSDictionary *)params progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (void)PostWithUrl:(NSString *)url params:(NSDictionary *_Nullable)params successBlock:(nullable void (^)(BOOL result, id _Nullable data ,NSString *msg))successBlock failureBlock:(nullable void (^)(BOOL result, NSString *error))failureBlock;

- (void)GetWithUrl:(NSString *)url successBlock:(nullable void (^)(BOOL result, id _Nullable data ,NSString *msg))successBlock failureBlock:(nullable void (^)(BOOL result, NSString *error))failureBlock;



- (void)PostWithUrl:(NSString *)url params:(NSDictionary *_Nullable)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress successBlock:(nullable void (^)(BOOL result, id _Nullable data))successBlock failureBlock:(nullable void (^)(BOOL result, NSString *error))failureBlock;

@end


FOUNDATION_EXTERN NSString * _Nullable SDURLEncodeURLQueryParamters(NSString * _Nullable   urlS,NSDictionary * _Nullable paramters);

NS_ASSUME_NONNULL_END

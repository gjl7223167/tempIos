//
//  TTSF_NetWorkManager.h
//  sale
//
//  Created by tianxiao bi on 2020/6/22.
//  Copyright © 2020 bjttsf. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef enum NetWorkType {
    NetWorkGet  = 0,
    NetWorkPost

} NetWorkType;
typedef enum RequestSerializerType {
    RequestSerializerHttp  = 0,
    RequestSerializerJson

} RequestSerializerType;

NS_ASSUME_NONNULL_BEGIN
@interface TTSF_NetWorkManager : AFHTTPSessionManager
+(instancetype)shareInstance;
-(void)requestType:(NetWorkType )netWorkType requestSerializerType:(RequestSerializerType)requestSerializerType urlString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(NSDictionary * _Nonnull responseObject))successBlock failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;
-(void)uploadFile:(NetWorkType )netWorkType requestSerializerType:(RequestSerializerType)requestSerializerType urlString:(NSString *)urlString imageArr:(NSMutableArray *)imageArr successBlock:(void (^)(NSDictionary * _Nonnull responseObject))successBlock failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;

@end

NS_ASSUME_NONNULL_END

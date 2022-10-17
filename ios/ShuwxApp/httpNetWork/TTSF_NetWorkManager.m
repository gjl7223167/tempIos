//
//  TTSF_NetWorkManager.m
//  sale
//
//  Created by tianxiao bi on 2020/6/22.
//  Copyright © 2020 bjttsf. All rights reserved.
//

#import "TTSF_NetWorkManager.h"
static TTSF_NetWorkManager *_singleInstance = nil;

@interface TTSF_NetWorkManager ()
@property(nonatomic,strong)NSArray * createUrlTypes;
@end

@implementation TTSF_NetWorkManager
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleInstance == nil) {
            _singleInstance = [[TTSF_NetWorkManager alloc]init];
            _singleInstance.responseSerializer = [AFJSONResponseSerializer serializer];
            _singleInstance.requestSerializer = [AFJSONRequestSerializer serializer];
            _singleInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
            _singleInstance.requestSerializer.timeoutInterval = 15;
            _singleInstance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            _singleInstance.securityPolicy.allowInvalidCertificates = YES;
            [_singleInstance.securityPolicy setValidatesDomainName:NO];
            //添加任务、创建商机、保存线索、保存联系人、常见客户、转入公海
            _singleInstance.createUrlTypes = @[SaveTask,CreateOpportunity,SaveClue,SaveContacts,CreatCustomer,TransferToHighSeas];
        }
    });
    return _singleInstance;
}
-(void)requestType:(NetWorkType )netWorkType requestSerializerType:(RequestSerializerType)requestSerializerType urlString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(NSDictionary * _Nonnull responseObject))successBlock failedBlock:(void (^)(NSError * _Nonnull error))failedBlock
{
    __weak typeof(self)WeakSelf = self;
    MBProgressHUD *hudIndicator = [MBProgressHUD showIndicator];
    if (hudIndicator) {
        [hudIndicator showAnimated:YES];
    }
    switch (requestSerializerType) {
        case RequestSerializerJson:
            _singleInstance.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
            
        default:
            _singleInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];//接口版本号为整数 不能去app版本号
    header[@"version"] = appVersion;
    [header setValue:[UserInfoModel shareInstance].token forKey:@"token"];
  
    switch (netWorkType) {
        case NetWorkGet:
        {
            [_singleInstance GET:[NSString stringWithFormat:@"%@%@",[BTXAPIManager hostUrl],urlString] parameters:parameters headers:header progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"%@",responseObject);
                NSInteger code = [responseObject[@"code"]integerValue];
                switch (code) {
                    case 10000:
                        successBlock(responseObject);
                        break;
                    case 30002:
                    {
                        UIViewController * tempCalss = [PubMethod currentViewController];
                        Class tempLoginVC = NSClassFromString(@"LoginHomeViewController");
                        if (![tempCalss isKindOfClass:[tempLoginVC class]]) {
                            ((UIWindow *)[PubMethod getWindow]).rootViewController = [[UINavigationController alloc]initWithRootViewController:[[tempLoginVC alloc]init]];
                        }
                    }
                        break;
                    default:
                    {
                        NSError *error = [[NSError alloc]init];
                        failedBlock(error);
                        [MBProgressHUD showToast:responseObject[@"msg"]];
                    }
                        
                        break;
                }
                [hudIndicator hideAnimated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"");
                failedBlock(error);
                [hudIndicator hideAnimated:YES];
            }];
            
        }
            break;
        case NetWorkPost:
        {
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",[BTXAPIManager hostUrl],urlString]);
            [_singleInstance POST:[NSString stringWithFormat:@"%@%@",[BTXAPIManager hostUrl],urlString] parameters:parameters headers:header progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSInteger code = [responseObject[@"code"]integerValue];
                switch (code) {
                    case 10000:
                        successBlock(responseObject);
                        break;
                    default:
                    {
                        NSError *error = [[NSError alloc]init];
                        failedBlock(error);
                        [MBProgressHUD showToast:responseObject[@"msg"]];
                    }
                        break;
                }
                
                if ([WeakSelf.createUrlTypes containsObject:urlString]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:vCircleItemBadgeValueNotification object:nil];
                }
                
                [hudIndicator hideAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failedBlock(error);
                [hudIndicator hideAnimated:YES];
            }];
            
        }
            break;
            
        default:
            break;
    }
    
}
-(void)uploadFile:(NetWorkType )netWorkType requestSerializerType:(RequestSerializerType)requestSerializerType urlString:(NSString *)urlString imageArr:(NSMutableArray *)imageArr successBlock:(void (^)(NSDictionary * _Nonnull responseObject))successBlock failedBlock:(void (^)(NSError * _Nonnull error))failedBlock
{
    
    MBProgressHUD *hudIndicator = [MBProgressHUD showIndicator];
    if (hudIndicator) {
        [hudIndicator showAnimated:YES];
    }

    switch (requestSerializerType) {
        case RequestSerializerJson:
            _singleInstance.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
            
        default:
            _singleInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    header[@"version"] = app_build;
    header[@"token"] = [UserInfoModel shareInstance].token;
    [_singleInstance POST:[NSString stringWithFormat:@"%@%@",[BTXAPIManager hostUrl],urlString] parameters:[[NSMutableDictionary alloc]init]headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArr.count; i++) {
        
            if ([imageArr[i] isKindOfClass:[UIImage class]]) {
                UIImage *image = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
            }
           
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        switch (code) {
            case 10000:
                successBlock(responseObject);
                break;
                
            default:
            {
                NSError *error = [[NSError alloc]init];
                failedBlock(error);
                [MBProgressHUD showToast:responseObject[@"msg"]];
            }
                break;
        }
         [hudIndicator hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
         [hudIndicator hideAnimated:YES];
    }];


}
@end

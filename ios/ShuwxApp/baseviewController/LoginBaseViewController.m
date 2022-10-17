//
//  LoginBaseViewController.m
//  ShuwxApp
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "BaseConst.h"

@implementation LoginBaseViewController
-(void)clearCookie{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
    for (id obj in _tmpArray) {
        [cookieStorage deleteCookie:obj];
    }
}
-(id) getMyResult:(id)responseObject{
//    if (nil == responseObject) {
//        NSString * result = @"获取结果为空";
//        LoginViewController * loginViewC = [[LoginViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = loginViewC;
//        return result;
//    }
//
//    if ([responseObject isKindOfClass:[NSString class]]) {
//        if ([responseObject containsString:@"<!DOCTYPE"]) {
//            NSString * result = @"登录失败！";
//            LoginViewController * loginViewC = [[LoginViewController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = loginViewC;
//            return result;
//        }
//    }
    
    int myCode = -1;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        myCode  = [[responseObject objectForKey:@"code"] integerValue];
    }
    
    if (myCode == 200) {
        id temArray = [responseObject objectForKey:@"data"];
        if (nil == temArray) {
            id itemsArr = [responseObject objectForKey:@"items"];
            if (nil == itemsArr) {
                id messStr =  [responseObject objectForKey:@"message"];
                return messStr;
            }
            return itemsArr;
        }
        return temArray;
    }
    NSString * myMessage =  [responseObject objectForKey:@"message"];
   
    if (myCode == 301) {
        [self setMainTain:responseObject];
         return @"维护阶段";
    }
    if (myCode == 302) {
        [self setMainTainTwo:responseObject];
         return @"强制更新";
    }
    
    return myMessage;
}
-(void)setMainTain:(NSMutableDictionary *)diction{
    
    NSString * myMessage =  [diction objectForKey:@"message"];
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"维护" message:myMessage ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        
    
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

-(void)setMainTainTwo:(NSMutableDictionary *)diction{
    
    NSString * myMessage =  [diction objectForKey:@"message"];
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"强制更新" message:myMessage ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        
        //        LoginViewController * loginViewC = [[LoginViewController alloc] init];
        //        [UIApplication sharedApplication].keyWindow.rootViewController = loginViewC;
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

// 获取 message
-(NSString *)getError:(NSError *)error{
    NSString * myMess = @"";
    myMess = error.localizedDescription;
    if ([myMess containsString:@"unacceptable content-type: text/html"]) {
        myMess = @"请重新登录！";
//        LoginViewController * loginViewC = [[LoginViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = loginViewC;
        return myMess;
    }
    return myMess;
}

-(void)setSaveAppStamp:(NSMutableDictionary *)dictionary{
//   NSString * company_name = [dictionary objectForKey:@"company_name"];
    NSString * appst_stamp = [dictionary objectForKey:@"appst_stamp"];
    NSString * logo_stamp = [dictionary objectForKey:@"logo_stamp"];
    NSString * ddfw_stamp = [dictionary objectForKey:@"ddfw_stamp"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * appst_stamp_get = [defaults objectForKey:@"appst_stamp"];
    NSString * logo_stamp_get = [defaults objectForKey:@"logo_stamp"];
    NSString * ddfw_stamp_get = [defaults objectForKey:@"ddfw_stamp"];
    
    if ([self getNSStringEqual:appst_stamp :appst_stamp_get] && [self getNSStringEqual:logo_stamp :logo_stamp_get] && [self getNSStringEqual:ddfw_stamp :ddfw_stamp_get]) {
        
    }else{
        [defaults setObject:appst_stamp forKey:@"appst_stamp"];
     [defaults setObject:logo_stamp forKey:@"logo_stamp"];
     [defaults setObject:ddfw_stamp forKey:@"ddfw_stamp"];
        [self getSelectCompanyDetailByCompanyId];
    }

}

-(void)getSelectCompanyDetailByCompanyId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
   
 
    NSString * url = [self getPinjieNSString:baseUrl :selectCompanyDetailByCompanyId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
              [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectWaitOrderPageList:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToastTwo:myResult];
        }
    
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
       
    }];
}
-(void)setSelectWaitOrderPageList:(NSMutableArray *) nsmutable{
    
    for (NSMutableDictionary * dicItem in nsmutable) {
      NSString * k_detail = [dicItem objectForKey:@"k_detail"];
        if (![self isBlankString:k_detail]) {
            if ([self getNSStringEqual:k_detail :@"appst"]) {
              NSString * v_varchar = [dicItem objectForKey:@"v_varchar"];
            }
            if ([self getNSStringEqual:k_detail :@"xtLogo"]) {
                NSString * v_varchar = [dicItem objectForKey:@"v_varchar"];
            }
            if ([self getNSStringEqual:k_detail :@"ddfw"]) {
                NSString * v_varchar = [dicItem objectForKey:@"v_varchar"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:v_varchar forKey:@"ddfw"];
            }
        }
    }
    
}



@end

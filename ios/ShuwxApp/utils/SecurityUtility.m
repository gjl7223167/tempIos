//
//  SecurityUtility.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SecurityUtility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SecurityUtility

//SHA256加密
+ (NSString*)sha256HashFor:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}

@end

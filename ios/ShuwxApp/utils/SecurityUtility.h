//
//  SecurityUtility.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtility : NSObject

//SHA256加密
+ (NSString*)sha256HashFor:(NSString *)input;

@end


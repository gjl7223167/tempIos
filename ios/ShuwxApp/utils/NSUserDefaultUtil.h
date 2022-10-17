//
//  NSUserDefaultUtil.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultUtil : NSObject

+(void)PutDefaults:(NSString *)key Value:(id)value;
+(id)GetDefaults:(NSString *)key;

@end


//
//  NSUserDefaultUtil.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "NSUserDefaultUtil.h"

@implementation NSUserDefaultUtil

+(void)PutDefaults:(NSString *)key Value:(id)value{
if (key!=NULL&&value!=NULL) {
NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
[userDefaults setObject:value forKey:key];
}
}
+(id)GetDefaults:(NSString *)key{
NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
id obj;
if (key!=NULL) {
obj=[userDefaults objectForKey:key];
}
return obj;
}

@end

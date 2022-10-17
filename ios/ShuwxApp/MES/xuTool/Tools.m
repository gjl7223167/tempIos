//
//  Tools.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/3/18.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(NSString *)getString:(id)data
{
    if ([data isKindOfClass:[NSNull class]]) {
        return @"暂无";
    }
    return [NSString stringWithFormat:@"%@",data];
}

+(NSString *)getEmptyString:(id)data
{
    if ([data isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",data];
}


@end

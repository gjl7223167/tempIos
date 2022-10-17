//
//  HLNetWorkReachability.h
//  ShuwxApp
//
//  Created by 袁小强 on 2021/5/16.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HLNetWorkStatus) {
    HLNetWorkStatusNotReachable = 0,
    HLNetWorkStatusUnknown = 1,
    HLNetWorkStatusWWAN2G = 2,
    HLNetWorkStatusWWAN3G = 3,
    HLNetWorkStatusWWAN4G = 4,
    HLNetWorkStatusWWAN5G = 5,
    
    HLNetWorkStatusWiFi = 9,
};

extern NSString *kNetWorkReachabilityChangedNotification;

@interface HLNetWorkReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (HLNetWorkStatus)currentReachabilityStatus;

@end

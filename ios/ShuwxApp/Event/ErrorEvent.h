//
//  ErrorEvent.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/11/30.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorEvent : NSObject
@property (copy ,nonatomic) NSString *errorId;
@property (strong ,nonatomic) NSMutableDictionary * diction;
@property (copy ,nonatomic) NSString *contentStr;
@property (strong ,nonatomic) id responser;
@end


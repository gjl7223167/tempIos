//
//  MyEventBus.h
//  ShuwxApp  EventBus
//
//  Created by 袁小强 on 2020/7/3.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTEventBus.h"

@interface MyEventBus : NSObject<QTEvent>
@property (strong ,nonatomic) NSString *errorId;
@property (strong ,nonatomic) NSMutableDictionary * diction;
@property (strong ,nonatomic) NSString *contentStr;

@end


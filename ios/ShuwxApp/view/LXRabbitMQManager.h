//
//  LXRabbitMQManager.h
//  RabbitMQDemo
//
//  Created by linxiang on 2017/7/4.
//  Copyright © 2017年 misrobot. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "DBBaseViewController.h"
typedef void (^ReturnValueBlock) (NSString *strValue);

//导入头文件
#import <RMQClient/RMQClient.h>

//NSString * const QueueName = @"LX";


@interface LXRabbitMQManager : NSObject
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic, strong) RMQConnection *conn;
@property (nonatomic, strong) id<RMQChannel> ch;
@property (nonatomic, strong) NSString *queueName;
@property (nonatomic, strong) NSString * myRoutingKey;

@property (nonatomic, strong) RMQQueue *q;
+ (LXRabbitMQManager *)sharedInstance;

- (void)Start;

- (void)Stop;

- (void)Restart;


- (void)startRabbitMQ:(NSString *) queueNameStr;

- (void)stopRabbitMQ;

-(void)sendText;

@end

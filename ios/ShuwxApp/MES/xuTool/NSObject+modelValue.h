//
//  NSObject+modelValue.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class propertyModel;
@interface NSObject (modelValue)

-(NSArray *)ModelArrayFromrecords:(NSArray *)recordsArr propertyInfo:(NSDictionary * __nullable)propertyInfoDic;

-(void)ModelArrayFromrecords:(NSArray *)recordsArr completion:(void(^)(NSDictionary *))completion;

-(void)ModelArrayHandleModelData;

-(NSArray<propertyModel *> *)ModelShowArrFromshowPosition:(NSInteger)Postion;

@end

NS_ASSUME_NONNULL_END

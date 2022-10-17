//
//  HyChartKLineConfigureDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineConfigureProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartKLineConfigureDataSourceProtocol <NSObject>

- (id<HyChartKLineConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartKLineConfigureProtocol> configure))block;

@property (nonatomic, strong, readonly) id<HyChartKLineConfigureProtocol> configure;

@end

NS_ASSUME_NONNULL_END

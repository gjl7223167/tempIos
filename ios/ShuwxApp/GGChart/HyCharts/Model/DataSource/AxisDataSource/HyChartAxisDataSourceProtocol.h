//
//  HyChartAxisDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartXAxisModelProtocol.h"
#import "HyChartYAxisModelProtocol.h"
#import "HyChartAxisGridLineInfoProtocol.h"
#import "HyChartsTypedef.h"


NS_ASSUME_NONNULL_BEGIN

/// 坐标轴数据源
@protocol HyChartAxisDataSourceProtocol <NSObject>


/// 配置X轴数据
- (id<HyChartAxisDataSourceProtocol>)configXAxisWithModel:(void(^)(id<HyChartXAxisModelProtocol> xAxisModel))block;

/// 配置Y轴数据
- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModel:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel))block;


/// 使用HyChartKlineView   配置Y轴数据
- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModelAndViewType:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel, HyChartKLineViewType type))block;


@end

NS_ASSUME_NONNULL_END

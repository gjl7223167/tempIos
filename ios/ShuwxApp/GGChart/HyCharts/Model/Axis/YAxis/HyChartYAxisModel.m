//
//  HyChartYAxisModel.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartYAxisModel.h"



@interface HyChartYAxisModel ()
@property (nonatomic, strong) HyChartYAxisInfo *leftYAxisInfo;
@property (nonatomic, strong) HyChartYAxisInfo *rightYAxisInfo;
@property (nonatomic, copy) NSNumber *(^yAxisMinValueBlock)(void);
@property (nonatomic, copy) NSNumber *(^yAxisMaxValueBlock)(void);
@end


@implementation HyChartYAxisModel
@synthesize leftYAxisDisabled = _leftYAxisDisabled, rightYAaxisDisabled = _rightYAaxisDisabled;
@synthesize yAxisMinValueExtraPrecent = _yAxisMinValueExtraPrecent, yAxisMaxValueExtraPrecent = _yAxisMaxValueExtraPrecent;

- (instancetype)init {
    if (self = [super init]) {
        _leftYAxisDisabled = NO;
        _rightYAaxisDisabled = YES;
    } return self;
}

- (id<HyChartYAxisModelProtocol>)configLeftYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block {
    !block ?: block(self.leftYAxisInfo);
    return self;
}

- (id<HyChartYAxisModelProtocol>)configRightYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block {
    !block ?: block(self.rightYAxisInfo);
    return self;
}

- (id<HyChartYAxisModelProtocol>)configYAxisMinValue:(NSNumber *(^)(void))block {
    self.yAxisMinValueBlock = [block copy];
    return self;
}

- (id<HyChartYAxisModelProtocol>)configYAxisMaxValue:(NSNumber *(^)(void))block {
    self.yAxisMaxValueBlock = [block copy];
    return self;
}

- (HyChartYAxisInfo *)leftYAxisInfo {
    if (self.leftYAxisDisabled) {
        return nil;
    }
    if (!_leftYAxisInfo){
        _leftYAxisInfo = [[HyChartYAxisInfo alloc] init];
    }
    return _leftYAxisInfo;
}

- (HyChartYAxisInfo *)rightYAxisInfo {
    if (self.rightYAaxisDisabled) {
        return nil;
    }
    if (!_rightYAxisInfo){
        _rightYAxisInfo = [[HyChartYAxisInfo alloc] init];
    }
    return _rightYAxisInfo;
}

@end

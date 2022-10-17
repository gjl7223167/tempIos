//
//  ProLabel.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/8/21.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProLabel : UILabel
@property (nonatomic,strong)NSString * deviceId;
@property (nonatomic,strong)NSString * dataId;
@property (nonatomic,strong)NSString * data_type;
@property (nonatomic,strong) NSString * positionStr;
@end

NS_ASSUME_NONNULL_END

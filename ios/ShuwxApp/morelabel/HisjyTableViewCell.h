//
//  HisjyTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/10/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

NS_ASSUME_NONNULL_BEGIN

@class XLHLookMoreLabel;
@class XLHModel;
@class HisjyTableViewCell;

@protocol XLHTableViewDelegate <NSObject>

- (void)tableViewCell:(HisjyTableViewCell *)cell model:(XLHModel *)model numberOfLines:(NSInteger)numberOfLines;

@end

@interface HisjyTableViewCell : UITableViewCell

@property(nonatomic,weak) id<XLHTableViewDelegate> delegate;
@property(nonatomic,strong) XLHModel *model;
@property(nonatomic,strong) XLHLookMoreLabel *label;
@property(nonatomic,strong) UILabel *bjTime;
@property(nonatomic,strong) UILabel *chulPerson;
@property(nonatomic,strong) UILabel *bjValue;
@property(nonatomic,strong) UILabel *bjReason;
@property(nonatomic,strong) UILabel *bjMethod;
@property(nonatomic,strong) UILabel *myView;
-(void)setValues:(XLHModel *)model;

@end

NS_ASSUME_NONNULL_END

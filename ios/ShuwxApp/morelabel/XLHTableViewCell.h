//
//  XLHTableViewCell.h
//  XLHLookMoreLabel
//
//  Created by 薛立恒 on 2019/3/6.
//  Copyright © 2019 薛立恒. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@class XLHLookMoreLabel;
@class XLHModel;
@class XLHTableViewCell;

@protocol XLHTableViewDelegateTwo <NSObject>

- (void)tableViewCell:(XLHTableViewCell *)cell model:(XLHModel *)model numberOfLines:(NSInteger)numberOfLines;

@end

@interface XLHTableViewCell : UITableViewCell

@property(nonatomic,weak) id<XLHTableViewDelegateTwo> delegate;
@property(nonatomic,strong) XLHModel *model;
@property(nonatomic,strong) XLHLookMoreLabel *label;
@property(nonatomic,strong) UILabel *careTime;
@property(nonatomic,strong) UILabel *carePerson;
@property(nonatomic,strong) UILabel *runTime;
@property(nonatomic,strong) UILabel *remakes;
@property(nonatomic,strong) UILabel *myView;

-(void)setValues:(XLHModel *)model;

@end


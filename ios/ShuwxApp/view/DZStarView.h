//
//  DZStarView.h
//  JSCoreDemo
//
//  Created by Jemmy on 2018/10/18.
//  Copyright © 2018年 Jemmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZStarView;
@protocol DZStarViewDelegate <NSObject>

-(void)starView:(DZStarView *)starView didClick:(NSInteger)index;

@end

@interface DZStarView : UIView

@property (nonatomic,assign)  BOOL canEvlaue;
@property (nonatomic,assign)  NSInteger maxCount;
@property (nonatomic,assign)  NSInteger value;
@property (nonatomic,weak) id<DZStarViewDelegate> delegate;

-(instancetype)initWithMaxCount:(NSInteger)count value:(NSInteger)value canEvlaue:(BOOL)evalue frame:(CGRect)frame;
-(void)setValue:(NSInteger)value;

@end


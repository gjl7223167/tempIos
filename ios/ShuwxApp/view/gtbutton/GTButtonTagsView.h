//
//  GTButtonTagsView.h
//  GTDynamicLabels
//
//  Created by 赵国腾 on 15/6/25.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProBtn.h"

@protocol GTButtonTagsViewDelegate;
@interface GTButtonTagsView : UIView{
@public int tempTag;
}
-(void)setDataList:(NSMutableArray *)dataList;

/**
 *  代理
 */
@property (nonatomic, weak) id<GTButtonTagsViewDelegate> delegate;

/**
 *  数据集合
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataButton;

@end


@protocol GTButtonTagsViewDelegate <NSObject>

- (void)GTButtonTagsView:(GTButtonTagsView *)view selectIndex:(NSInteger)index selectText:(NSString *)text;

@end

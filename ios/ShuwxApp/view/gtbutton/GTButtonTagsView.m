//
//  GTButtonTagsView.m
//  GTDynamicLabels
//
//  Created by 赵国腾 on 15/6/25.
//  Copyright (c) 2015年 zhaoguoteng. All rights reserved.
//

#import "GTButtonTagsView.h"

const CGFloat intervalWide = 10.0f;     // label间隔宽度

@interface GTButtonTagsView ()

@property (nonatomic, assign) CGRect currentLabelFrame;

@end

@implementation GTButtonTagsView

-(NSMutableArray *)dataSource{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)dataButton{
    if (!_dataButton) {
        _dataButton = [NSMutableArray array];
    }
    return _dataButton;
}

-(void)setDataList:(NSMutableArray *)dataList{
    self.dataArr = dataList;
    
    // 布局label
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        
        NSString *str = self.dataArr[i];
        
        CGFloat x = self.currentLabelFrame.origin.x + self.currentLabelFrame.size.width;
        
        CGFloat y = self.currentLabelFrame.origin.y;
        
        if (i != 0) {
            x += intervalWide;
        }else {
            y += intervalWide;
        }
        
        CGSize size = [self labelSizeFromString:str];
        
        // 判断label是否到视图边界
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        
        size.height = 30.0f;
        
        if (maxX > CGRectGetWidth(self.frame)) {
            
            x -= minX;
            y = y + size.height + intervalWide;
        }
        
        // 计算label的frame
        CGRect rect = CGRectMake(x, y, size.width, size.height);
        
        self.currentLabelFrame = rect;
        
        ProBtn *button = [ProBtn buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        //        button.backgroundColor = [UIColor yellowColor];
        [button setTitle:str forState:UIControlStateNormal];
        
        //        button.backgroundColor = [UIColor blueColor];
        
        //设置圆角的半径
        [button.layer setCornerRadius:15];
        
        //切割超出圆角范围的子视图
        button.layer.masksToBounds = YES;
        NSString *tagStr = [NSString stringWithFormat:@"%d",i];
         button.userId = tagStr;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.dataButton addObject:button];
        [self addSubview:button];
}
}


- (void)awakeFromNib {
    
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"labels.plist" ofType:nil];
//    self.dataArr = [NSArray arrayWithContentsOfFile:plistPath];
    
    [self dataSource];
    [self dataButton];
    tempTag = -1;
    
    self.currentLabelFrame = CGRectZero;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

// 根据文本计算label宽度
- (CGSize)labelSizeFromString:(NSString *)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f]};
    return [str sizeWithAttributes:attributes];
}
// 标签点击事件
- (void)buttonAction:(ProBtn *)sender {
     int myTag =  [sender.userId intValue];
    for (ProBtn * myButton in self.dataButton) {
         myButton.selected = NO;
                    //设置边框的颜色
                    [myButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
                    //设置边框的粗细
                    [myButton.layer setBorderWidth:0.0];
    }
    if (tempTag != myTag) {
           sender.selected = YES;
        //设置边框的颜色
        [sender.layer setBorderColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor];
        
        [self.delegate GTButtonTagsView:self selectIndex:myTag  selectText:sender.titleLabel.text];
        [sender.layer setBorderWidth:1.0];
        tempTag = myTag;
    }else{
        sender.selected = NO;
        //设置边框的颜色
        [sender.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
        //设置边框的粗细
        [sender.layer setBorderWidth:0.0];
        
          [self.delegate GTButtonTagsView:self selectIndex:myTag selectText:@""];
    }
    
}

@end

//
//  TestCollectionCell.m
//  DKSTableCollcetionView
//
//  Created by aDu on 2017/10/10.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootCollectionCell.h"

@interface RootCollectionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RootCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        self.backgroundView = self.label;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTextStr:(NSString *)textStr {
    if (self.textStr != textStr) {
        self.textStr = textStr;
        self.label.text = textStr;
    }
}

@end

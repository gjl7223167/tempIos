//
//  NeedView.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/4.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "NeedView.h"

@implementation NeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NeedView *aaView = [[[NSBundle mainBundle] loadNibNamed:@"NeedView" owner:self options:nil] lastObject];
        
       UINib *nib = [UINib nibWithNibName:@"NeedView" bundle:nil];
               NeedView *aaView = [[nib instantiateWithOwner:nil options:nil] lastObject];
       [self addSubview:aaView];
        _webName = aaView.webName;
        _deviceView = aaView.deviceView;
        _oneView = aaView.oneView;
        _twoView = aaView.twoView;
        _needTextView = aaView.needTextView;
        _optoolTextView = aaView.optoolTextView;
        _needView = aaView.needView;
        _noRequstView = aaView.noRequstView;
        _gpsAllView = aaView.gpsAllView;
        _gpsContentValue = aaView.gpsContentValue;
        _resetGpsView = aaView.resetGpsView;
        _ddPointButton = aaView.ddPointButton;
    
        [self initView];
    }
    return self;
}
-(void)initView{
//  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2:)];
//            [self.oneView addGestureRecognizer:gesture];

}

//-(void)tagGesture2:(UITapGestureRecognizer *)myTopTwo{
//    NSLog(@"ggg");
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
//    CGPoint buttonPoint = [underButton convertPoint:point fromView:self];
//    if ([underButton pointInside:buttonPoint withEvent:event]) {
//        return underButton;
//    }
    return result;
}


@end

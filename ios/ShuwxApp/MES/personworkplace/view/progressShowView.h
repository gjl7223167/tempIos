//
//  progressShowView.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/3.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface progressShowView : UIView

@property(nonatomic ,strong) UILabel *Numlabel;

@property(nonatomic ,strong) UILabel *textlabel;
@property(nonatomic ,strong) UIView *foreV;
@property(nonatomic ,strong) UIView *myView;

-(void)setProgress:(NSInteger)total part:(NSInteger)part;

@end

NS_ASSUME_NONNULL_END

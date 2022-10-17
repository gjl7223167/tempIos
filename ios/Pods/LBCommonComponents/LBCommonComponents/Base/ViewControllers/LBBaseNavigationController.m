//
//  LBBaseNavigationController.m
//  LBBaseNavigationController
//
//  Created by 刘彬 on 2020/9/4.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBBaseNavigationController.h"

@interface LBBaseNavigationController ()

@end

@implementation LBBaseNavigationController
#pragma mark 处理tabbar的显示隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}

@end

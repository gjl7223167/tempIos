//
//  UIViewController+LBNavigationBarAppearance.m
//
//  Created by 刘彬 on 2020/10/14.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "UIViewController+LBNavigationBarAppearance.h"
#import "NSObject+LBMethodSwizzling.h"

static NSString *LBNavigationBarAppearanceStyleKey = @"LBNavigationBarAppearanceStyleKey";
static NSString *LBNavigationBarTintColorKey = @"LBNavigationBarTintColorKey";

@interface UIViewController (LBNavigationBarAppearance)
@property (nonatomic, assign) LBNavigationBarAppearanceStyle navigationBarAppearanceStyle;
@property (nonatomic, strong, nullable) UIColor *navigationBarTintColor;
@end

@implementation UIViewController (LBNavigationBarAppearance)

+(void)load{
    [self lb_swizzleMethodClass:self.class
                         method:@selector(viewDidLoad)
          originalIsClassMethod:NO
                      withClass:self
                     withMethod:@selector(lb_navigationBarAppearance_viewDidLoad)
          swizzledIsClassMethod:NO];
    
    
    [self lb_swizzleMethodClass:self.class
                         method:@selector(viewWillAppear:)
          originalIsClassMethod:NO
                      withClass:self
                     withMethod:@selector(lb_navigationBarAppearance_viewWillAppear:)
          swizzledIsClassMethod:NO];
    
    [self lb_swizzleMethodClass:self.class
                         method:@selector(addChildViewController:)
          originalIsClassMethod:NO
                      withClass:self
                     withMethod:@selector(lb_navigationBarAppearance_addChildViewController:)
          swizzledIsClassMethod:NO];
}

-(LBNavigationBarAppearanceStyle)navigationBarAppearanceStyle{
    return [objc_getAssociatedObject(self, &LBNavigationBarAppearanceStyleKey) integerValue];
}
-(void)setNavigationBarAppearanceStyle:(LBNavigationBarAppearanceStyle)navigationBarAppearanceStyle{
    objc_setAssociatedObject(self, &LBNavigationBarAppearanceStyleKey, @(navigationBarAppearanceStyle), OBJC_ASSOCIATION_ASSIGN);
    
    if (navigationBarAppearanceStyle == LBNavigationBarHidden && self.navigationController.navigationBarHidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if (self.navigationController.navigationBarHidden == YES){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
-(UIColor *)navigationBarTintColor{
    return objc_getAssociatedObject(self, &LBNavigationBarTintColorKey);
}
- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor{
    objc_setAssociatedObject(self, &LBNavigationBarTintColorKey, navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setNavigationBarAppearanceStyle:(LBNavigationBarAppearanceStyle)style tintColor:(nullable UIColor *)color{
    self.navigationBarAppearanceStyle = style;
    self.navigationBarTintColor = color;
}

-(void)lb_navigationBarAppearance_viewDidLoad{
    if ([NSStringFromClass(self.class) hasPrefix:@"UI"] == NO) {
        if (self.view.backgroundColor == nil) {
            if (@available(iOS 13.0, *)) {
                self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
            } else {
                self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            }
        }
    }
    [self lb_navigationBarAppearance_viewDidLoad];
}

-(void)lb_navigationBarAppearance_viewWillAppear:(BOOL)animated{
    if ([NSStringFromClass(self.class) hasPrefix:@"UI"] == NO &&
        self.navigationController != nil){
        
        NSString *backBarButtonItemTitle = [UINavigationBar appearance].lb_backItemTitle;
        if (backBarButtonItemTitle != self.navigationItem.backBarButtonItem.title) {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backBarButtonItemTitle style:UIBarButtonItemStylePlain target:self action:nil];
        }
        
        if ([UINavigationBar appearance].lb_appearanceAvailable == YES) {
            
            if (@available(iOS 15.0, *)) {
                UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
                self.navigationController.navigationBar.standardAppearance = appearance;
                self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
            }
            
            switch (self.navigationBarAppearanceStyle) {
                case LBNavigationBarTransparent:
                case LBNavigationBarTransparentShadowLine:
                {
                    if (self.navigationController.isNavigationBarHidden == YES) {
                        [self.navigationController setNavigationBarHidden:NO animated:YES];
                    }
                    
                    if (@available(iOS 15.0, *)) {
                        self.navigationController.navigationBar.scrollEdgeAppearance.backgroundEffect = nil;
                    }else{
                        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                    }
                    
                    if (self.navigationBarAppearanceStyle != LBNavigationBarTransparentShadowLine) {
                        if (@available(iOS 15.0, *)) {
                            self.navigationController.navigationBar.scrollEdgeAppearance.shadowColor = [UIColor clearColor];
                        }else{
                            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
                        }
                        
                    }
                    
                    if (self.navigationBarTintColor) {
                        if (@available(iOS 15.0, *)) {
                            self.navigationController.navigationBar.scrollEdgeAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:self.navigationBarTintColor};
                        }else{
                            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.navigationBarTintColor}];
                        }

                        self.navigationController.navigationBar.tintColor = self.navigationBarTintColor;
                    }

                    if ([self.navigationBarTintColor isEqual:[UIColor whiteColor]]) {
                        self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //状态栏改为白色
                    }else{
                        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;  //状态栏改为默认
                    }
                }
                    break;
                    break;
                case LBNavigationBarHidden:
                    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;  //状态栏改为默认

                    [self.navigationController setNavigationBarHidden:YES animated:YES];
                    break;
                default:
                    if (self.navigationController.isNavigationBarHidden == YES) {
                        [self.navigationController setNavigationBarHidden:NO animated:YES];
                    }

                    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                    [self.navigationController.navigationBar setShadowImage:nil];
                    [self.navigationController.navigationBar setTitleTextAttributes:nil];
                    
                    if (@available(iOS 13.0, *)) {
                        UIColor *tintColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                                return [UIColor blackColor];
                            }
                            else {
                                return [UIColor whiteColor];
                            }
                        }];
                        self.navigationController.navigationBar.tintColor = tintColor;
                    }else{
                        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                    }
                    
                    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;  //状态栏改为默认

                    break;
            }
        }
        
    }
    
    [self lb_navigationBarAppearance_viewWillAppear:animated];
    
}
-(void)lb_navigationBarAppearance_addChildViewController:(UIViewController *)childController{
    if ([NSStringFromClass(self.class) hasPrefix:@"UI"] == NO &&
        self.navigationController != nil){
        [childController setNavigationBarAppearanceStyle:self.navigationBarAppearanceStyle tintColor:self.navigationBarTintColor];
    }
    [self lb_navigationBarAppearance_addChildViewController:childController];
}

@end

static NSString *LBNavigationBarAppearanceAvailableKey = @"LBNavigationBarAppearanceAvailableKey";
static NSString *LBBackItemTitleKey = @"LBBackItemTitleKey";

@implementation UINavigationBar (LBAppearance)
- (void)setLb_appearanceAvailable:(BOOL)lb_appearanceAvailable{
    objc_setAssociatedObject(self, &LBNavigationBarAppearanceAvailableKey, @(lb_appearanceAvailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)lb_appearanceAvailable{
    return [objc_getAssociatedObject(self, &LBNavigationBarAppearanceAvailableKey) doubleValue];
}

-(void)setLb_backItemTitle:(NSString *)lb_backItemTitle{
    objc_setAssociatedObject(self, &LBBackItemTitleKey, lb_backItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)lb_backItemTitle{
    return objc_getAssociatedObject(self, &LBBackItemTitleKey);
}
@end

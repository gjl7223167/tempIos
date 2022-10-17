//
//  UIControl+LBEventInterval.m
//  Site
//
//  Created by 刘彬 on 2020/9/4.
//  Copyright © 2020 yc. All rights reserved.
//

#import "UIControl+LBEventInterval.h"
#import <objc/runtime.h>

static char * const lb_eventIntervalKey = "lb_eventIntervalKey";
static char * const lb_eventUnavailableKey = "lb_eventUnavailableKey";

@implementation UIControl (LBEventInterval)

+ (void)load {
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method qi_method = class_getInstanceMethod(self, @selector(lb_eventInterval_sendAction:to:forEvent:));
    method_exchangeImplementations(method, qi_method);
}

#pragma mark - Action functions
- (void)lb_eventInterval_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if([self isKindOfClass:[UIButton class]]) {
        if (self.lb_eventUnavailable == NO) {
              self.lb_eventUnavailable = YES;
              [self lb_eventInterval_sendAction:action to:target forEvent:event];
              [self performSelector:@selector(setLb_eventUnavailable:) withObject:0           afterDelay:self.lb_eventInterval];
        }
   } else {
        [self lb_eventInterval_sendAction:action to:target forEvent:event];
    }
}


#pragma mark - Setter & Getter functions

- (NSTimeInterval)lb_eventInterval {
    
    return [objc_getAssociatedObject(self, lb_eventIntervalKey) doubleValue];
}

- (void)setLb_eventInterval:(NSTimeInterval)qi_eventInterval {
    
    objc_setAssociatedObject(self, lb_eventIntervalKey, @(qi_eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lb_eventUnavailable {
    
    return [objc_getAssociatedObject(self, lb_eventUnavailableKey) boolValue];
}

- (void)setLb_eventUnavailable:(BOOL)eventUnavailable {
    
    objc_setAssociatedObject(self, lb_eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

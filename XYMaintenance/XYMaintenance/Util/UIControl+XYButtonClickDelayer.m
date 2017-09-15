//
//  UIControl+XYButtonClickDelayer.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/23.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "UIControl+XYButtonClickDelayer.h"
#import <objc/runtime.h>


static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_uxy_ignoreEvent = "UIControl_uxy_ignoreEvent";

@implementation UIControl (XYButtonClickDelayer)

+ (void)load{
    
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}


- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.uxy_ignoreEvent) return;
    
    if (self.uxy_acceptEventInterval > 0){
        self.uxy_ignoreEvent = true;
        // want to performSelecor with flag=NO use  不定期发生的史前巨坑。。。
//        [object performSelector:@selector(doSomething:) withObject:nil];
//        In case of flag=YES you can send any object, for example, @YES - number from bool
//            [object performSelector:@selector(doSomething:) withObject:@YES];
        [self performSelector:@selector(setUxy_ignoreEvent:) withObject:nil afterDelay:self.uxy_acceptEventInterval];
    }
    
    [self __uxy_sendAction:action to:target forEvent:event];
}

#pragma mark - setter & getter

- (NSTimeInterval)uxy_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)uxy_ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_uxy_ignoreEvent) boolValue];
}

- (void)setUxy_ignoreEvent:(BOOL)uxy_ignoreEvent{
    objc_setAssociatedObject(self, UIControl_uxy_ignoreEvent, @(uxy_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//
//  MethodSwizzle.m
//  MobileGjp
//
//  Created by chao luo on 4/25/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import "MethodSwizzle.h"

void SwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void SwizzleClassMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    method_exchangeImplementations(class_getClassMethod(cls, originalSelector), class_getClassMethod(cls, swizzledSelector));
}

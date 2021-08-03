//
//  MethodSwizzle.h
//  MobileGjp
//
//  Created by chao luo on 4/25/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern void SwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

extern void SwizzleClassMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

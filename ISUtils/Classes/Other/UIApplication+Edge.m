//
//  UIApplication+Edge.m
//  MobileGjp
//
//  Created by chao luo on 5/23/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import "UIApplication+Edge.h"

@implementation UIApplication (Edge)

- (UIEdgeInsets)windowSafeArea {
    CGFloat top = self.statusBarFrame.size.height;
    CGFloat left = 0, bottom = 0, right = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = self.keyWindow;
        bottom = MAX(window.safeAreaInsets.bottom, bottom);
        top = MAX(window.safeAreaInsets.top, top);
        left = window.safeAreaInsets.left;
        right = window.safeAreaInsets.right;
    }
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)windowSafeTop {
    return [self windowSafeArea].top;
}

- (CGFloat)windowSafeBottom {
    return [self windowSafeArea].bottom;
}

- (CGFloat)windowSafeHeight {
    return self.keyWindow.bounds.size.height - [self windowSafeArea].top - [self windowSafeArea].bottom;
}

- (CGFloat)windowSafeWith {
    return self.keyWindow.bounds.size.width - [self windowSafeArea].left - [self windowSafeArea].right;
}

@end

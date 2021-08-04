//
//  UIBarButtonItem+CLAwesome.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CLAwesome)

// navigationItem
+ (UIBarButtonItem *)leftButtonItemImage:(UIImage *)image target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)leftButtonItemTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)rightButtonItemImage:(UIImage *)image target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)rightButtonItemTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)redButtonItemImage:(nullable UIImage *)image title:(nullable NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)buttonItemImage:(nullable UIImage *)image title:(nullable NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)buttonItemImage:(nullable UIImage *)image title:(nullable NSString *)title fontSize:(CGFloat)fontSize tilteColor:(uint32_t)hex target:(id)target selector:(SEL)selector;

@end

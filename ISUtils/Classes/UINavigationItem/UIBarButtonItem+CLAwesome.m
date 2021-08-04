//
//  UIBarButtonItem+CLAwesome.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIBarButtonItem+CLAwesome.h"
#import "../UIColor/UIColor+CLHex.h"

@implementation UIBarButtonItem (CLAwesome)

+ (UIBarButtonItem *)leftButtonItemImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)leftButtonItemTitle:(NSString *)title target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBHex:0x333333] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)rightButtonItemTitle:(NSString *)title target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBHex:0x333333] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)rightButtonItemImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)redButtonItemImage:(nullable UIImage *)image title:(nullable NSString *)title target:(id)target selector:(SEL)selector {
    return [self buttonItemImage:image title:title fontSize:14 tilteColor:0xF24040 target:target selector:selector];
}

+ (UIBarButtonItem *)buttonItemImage:(nullable UIImage *)image title:(nullable NSString *)title target:(id)target selector:(SEL)selector {
    return [self buttonItemImage:image title:title fontSize:14 tilteColor:0x333333 target:target selector:selector];
}

+ (UIBarButtonItem *)buttonItemImage:(nullable UIImage *)image title:(nullable NSString *)title fontSize:(CGFloat)fontSize tilteColor:(uint32_t)hex target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width+3, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRGBHex:hex] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

@end

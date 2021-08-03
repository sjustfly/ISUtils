//
//  UINavigationItem+CLMargin.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/20.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double UINavigationItem_MarginVersionNumber;
FOUNDATION_EXPORT const unsigned char UINavigationItem_MarginVersionString[];

@interface UINavigationItem (CLMargin)

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

+ (CGFloat)systemMargin;

@end

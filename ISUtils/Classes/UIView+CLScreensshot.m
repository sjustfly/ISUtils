//
//  UIView+CLScreensshot.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIView+CLScreensshot.h"

@implementation UIView (CLScreensshot)

/**
 *  @brief  view截图
 *
 *  @return view出渲染的image
 */
- (UIImage *)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage* screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end

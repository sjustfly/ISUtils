//
//  UILabel+Expanded.m
//  SAX_iOS
//
//  Created by 普拉斯 on 16/10/18.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "UILabel+Expanded.h"
#import "UIColor+CLHex.h"
#import <objc/runtime.h>
#import "MethodSwizzle.h"

static char labelEdgeKey;

@implementation UILabel (Expanded)

+ (UILabel *)labelWithFontSize:(CGFloat)size color:(uint32_t)hex {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor colorWithRGBHex:hex];
    return label;
}

+ (void)load {
    SwizzleMethod(self, NSSelectorFromString(@"drawTextInRect:"), @selector(label_edges_swizzled_drawTextInRect:));
    SwizzleMethod(self, NSSelectorFromString(@"textRectForBounds:limitedToNumberOfLines:"), @selector(label_edges_swizzled_textRectForBounds:limitedToNumberOfLines:));
}

- (CGRect)label_edges_swizzled_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect edge = UIEdgeInsetsInsetRect(bounds, insets);
    CGRect rect = [self label_edges_swizzled_textRectForBounds:edge limitedToNumberOfLines:numberOfLines];
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom + 0.5); // + 0.5 是为了解决有的文字不换行
    return rect;
}

- (void)label_edges_swizzled_drawTextInRect:(CGRect)rect {
    [self label_edges_swizzled_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (UIEdgeInsets)edgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &labelEdgeKey);
    if (value) {
        return [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:edgeInsets];
    objc_setAssociatedObject(self, &labelEdgeKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


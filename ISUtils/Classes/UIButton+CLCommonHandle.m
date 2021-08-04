//
//  UIButton+CLCommonHandle.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIButton+CLCommonHandle.h"
#import <objc/runtime.h>
#import "MethodSwizzle.h"

// Associative reference keys.
static NSString *const indicatorViewKey = @"indicatorView";
static NSString *const buttonTextObjectKey = @"buttonTextObject";

static NSString *const kCLImagePositionMark = @"kCLImagePositionMark";
static NSString *const kCLImagePosition = @"kCLImagePosition";
static NSString *const kCLImagePositionSpacing = @"kCLImagePositionSpacing";

@implementation UIButton (CLCommonHandle)

+ (void)load {
    SwizzleMethod(self, @selector(layoutSubviews), @selector(swizzle_layoutSubviews));
}

- (void)swizzle_layoutSubviews {
    [self swizzle_layoutSubviews];
    BOOL marked = [objc_getAssociatedObject(self, &kCLImagePositionMark) boolValue];
    if (marked) {
        CLImagePosition postion = [objc_getAssociatedObject(self, &kCLImagePosition) integerValue];
        CGFloat spacing = [objc_getAssociatedObject(self, &kCLImagePositionSpacing) floatValue];
        [self setImagePosition:postion spacing:spacing];
    }
}

- (void)setImagePosition:(CLImagePosition)postion {
    [self setImagePosition:postion spacing:0];
}

- (void)setImagePosition:(CLImagePosition)postion spacing:(CGFloat)spacing {
    objc_setAssociatedObject(self, &kCLImagePositionMark, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kCLImagePosition, @(postion), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kCLImagePositionSpacing, @(spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGSize titleSize = [self sizeForText:[self titleForState:UIControlStateNormal] font:self.titleLabel.font size:CGSizeMake(HUGE, HUGE) mode:self.titleLabel.lineBreakMode];

    if (self.titleLabel.adjustsFontSizeToFitWidth && (postion == CLImagePositionLeft || postion == CLImagePositionRight)) {
       self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }

    switch (postion) {
       case CLImagePositionLeft: {
           self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
           self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
           break;
       }
       case CLImagePositionRight: {
           self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width + spacing);
           self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + spacing, 0, - self.titleLabel.frame.size.width - spacing);
           break;
       }
       case CLImagePositionTop: {
           // lower the text and push it left so it appears centered
           //  below the image
           self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (imageSize.height + spacing), 0);
           
           // raise the image and push it right so it appears centered
           //  above the text
           self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0, 0, - titleSize.width);
           break;
       }
       case CLImagePositionBottom: {
           self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), - imageSize.width, 0, 0);
           self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, - (titleSize.height + spacing), - titleSize.width);
           break;
       }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton b_imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)b_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)showIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &buttonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &indicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
}

- (void)hideIndicator {
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &buttonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &indicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
    
}

#pragma mark - Drawing
- (CGSize)sizeForText:(NSString *)text font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [text sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

@end

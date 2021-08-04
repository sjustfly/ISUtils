//
//  UIColor+CLHex.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIColor+CLHex.h"

@implementation UIColor (CLHex)

+ (UIColor *) colorWithString: (NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    if (![scanner scanString:@"{" intoString:NULL]) return nil;
    
    static const NSUInteger kMaxComponents = 4;
    float c[4] = {0};
    NSUInteger i = 0;
    
    if (![scanner scanFloat: &c[i++]]) return nil;
    
    while (true) {
        if ([scanner scanString:@"}" intoString:NULL]) break;
        if (i >= kMaxComponents) return nil;
        if ([scanner scanString:@"," intoString:NULL]) {
            if (![scanner scanFloat: &c[i++]]) return nil;
        } else {
            // either we're at the end of there's an unexpected character here
            // both cases are error conditions
            return nil;
        }
    }
    if (![scanner isAtEnd]) return nil;
    UIColor *color = nil;
    switch (i) {
        case 2: // monochrome
            color = [UIColor colorWithWhite:c[0] alpha:c[1]];
            break;
        case 4: // RGB
            color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *) colorWithRGBHex: (uint32_t)hex {
    unsigned char r = (hex >> 16) & 0xFF;
    unsigned char g = (hex >> 8) & 0xFF;
    unsigned char b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString*)string {
    return [self colorWithRGBHexString:string];
}

+ (UIColor *) colorWithARGBHex: (uint32_t)hex {
    unsigned char r = (hex >> 16) & 0xFF;
    unsigned char g = (hex >> 8) & 0xFF;
    unsigned char b = (hex) & 0xFF;
    unsigned char a = (hex >> 24) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
// Added "#" consumer -- via Arnaud Coomans
+ (UIColor *) colorWithRGBHexString: (NSString *)stringToConvert {
    NSString *string = stringToConvert;
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum = 0;
    if (![scanner scanHexInt: &hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *) colorWithARGBHexString: (NSString *)stringToConvert {
    NSString *string = stringToConvert;
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum = 0;
    if (![scanner scanHexInt: &hexNum]) return nil;
    return [UIColor colorWithARGBHex:hexNum];
}

- (CGFloat)red {
    return [self componentAtIndex:0];
}

- (CGFloat)green {
    return [self componentAtIndex:1];
}

- (CGFloat)blue {
    return [self componentAtIndex:2];
}

- (CGFloat)alpha {
    return [self componentAtIndex:3];
}

- (CGFloat)componentAtIndex:(NSInteger)index {
    CGFloat t = 0;
    CGColorRef color = [self CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(color);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(color);
        t = components[index];
    }
    return t;
}

+ (UIImage *)createImageWithColor:(UIColor*)color
{
    return [UIColor createImageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)createImageWithColor:(UIColor*)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)specialRandomColor {
    CGFloat hue = arc4random() % 256 / 256.0 ;  //  0.0 to 1.0
    CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert alpha:(CGFloat)alpha{
    if([stringToConvert isEqualToString:@""] || !stringToConvert)
        return [UIColor whiteColor];
    
    stringToConvert = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    
    //例子，stringToConvert #ffffff
    if ([stringToConvert length] < 6){
        return [UIColor whiteColor];//如果非十六进制，返回白色
    }
    if ([stringToConvert hasPrefix:@"#"])
        stringToConvert = [stringToConvert substringFromIndex:1];//去掉头
    if ([stringToConvert length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (CAGradientLayer *)colorGradientRampWithColorStart:(NSString *)colorStart alphaStart:(CGFloat)as colorEnd:(NSString *)colorEnd alphaEnd:(CGFloat)ae frame:(CGRect)frame {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;  // 设置显示的frame
    gradientLayer.colors = @[(id)[UIColor colorWithARGBString:colorStart alpha:as].CGColor,(id)[UIColor colorWithARGBString:colorEnd alpha:ae].CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(0, 1);     //
    return gradientLayer;
}

+ (UIImage *)imageFromColors:(NSArray*)colors size:(CGSize)size {
    NSMutableArray *ar = [NSMutableArray array];
    for(NSString *c in colors) {
        UIColor *color = [UIColor colorWithARGBString:c alpha:1];
        [ar addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace((CGColorRef)[ar lastObject]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(size.width, 0.0);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIColor *)colorGradientChangeWithSize:(CGSize)size startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    return [UIColor colorWithPatternImage:[UIColor imageGradientChangeWithSize:size startColor:startcolor endColor:endColor]];
}

+ (UIImage *)imageGradientChangeWithSize:(CGSize)size startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointMake(1.0, 0.0);
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

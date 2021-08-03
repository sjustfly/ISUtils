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

@end

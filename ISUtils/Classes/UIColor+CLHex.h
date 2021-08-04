//
//  UIColor+CLHex.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISUtils.h"
///常用颜色
#define black_color     [UIColor blackColor]
#define blue_color      [UIColor blueColor]
#define brown_color     [UIColor brownColor]
#define clear_color     [UIColor clearColor]
#define darkGray_color  [UIColor darkGrayColor]
#define darkText_color  [UIColor darkTextColor]
#define white_color     [UIColor whiteColor]
#define yellow_color    [UIColor yellowColor]
#define red_color       [UIColor redColor]
#define orange_color    [UIColor orangeColor]
#define purple_color    [UIColor purpleColor]
#define lightText_color [UIColor lightTextColor]
#define lightGray_color [UIColor lightGrayColor]
#define green_color     [UIColor greenColor]
#define gray_color      [UIColor grayColor]
#define magenta_color   [UIColor magentaColor]


#define kThemeColor KRGBString(@"#40CCC0")
// 主背景色
#define kBackgroundColor kRGBA(248, 248, 248, 1)
// 分割线
#define kSeparatorColor KRGBString(@"#DDDDDD")

/********************************************* 颜色设置 *******************************/
#define kRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define KRGBString(RGB) [UIColor colorWithRGBHexString:RGB]
#define kRandomColor    RGB(arc4random()%256,arc4random()%256,arc4random()%256)

#define kDefaultColor   KRGBString(@"#e0e0e0")
// 颜色
#define RGB(A,B,C) [UIColor colorWithRed:(A)/255.0 green:(B)/255.0 blue:(C)/255.0 alpha:1.0]
#define kRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/********************************************* 常用颜色 *******************************/
#define KColor_EEEEEE   KRGBString(@"#EEEEEE")  ///< 分割线颜色
#define KColor_EBEBEB   KRGBString(@"#EBEBEB")  ///< 分割线颜色2
#define KColor_D2D2D2   KRGBString(@"#D2D2D2")  ///< 比浅灰浅，比分割线浓
#define KColor_D3D3D3   KRGBString(@"#D3D3D3")  ///< 比浅灰浅2
#define KColor_B0B0B0   KRGBString(@"#B0B0B0")  ///< 常用浅灰
#define KColor_White    [UIColor whiteColor]    ///< 纯白
#define KColor_Black    [UIColor blackColor]    ///< 纯黑
#define KColor_333333   KRGBString(@"#333333")  ///< 浅一点的黑
#define KColor_666666   KRGBString(@"#666666")  ///< 灰色
#define KColor_FF5266   KRGBString(@"#FF5266")  ///< 红色
#define KColorLigthGray KRGBString(@"#999999")  ///< 浅灰字体色

@interface UIColor (CLHex)

// {r, g, b, a} --> {0.3, 1, 0.5, 1}
+ (UIColor *) colorWithString: (NSString *) string;
// "0x65ce00" or "#0x65ce00"
+ (UIColor *) colorWithRGBHexString: (NSString *)stringToConvert;
+ (UIColor *) colorWithRGBHex: (uint32_t)hex;
+ (UIColor*)colorWithHexString:(NSString*)string;

// "0xff65ce00" or "#0xff65ce00"
+ (UIColor *) colorWithARGBHexString: (NSString *)stringToConvert;
+ (UIColor *) colorWithARGBHex: (uint32_t)hex;

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

+ (UIColor *)specialRandomColor;
+ (UIColor *)getColor:(NSString*)hexColor;
+ (UIImage *)createImageWithColor:(UIColor*)color; // 创建纯色图片
+ (UIImage *)createImageWithColor:(UIColor*)color size:(CGSize)size;  // 纯色图片
///< 根据hex值获得UIColor
+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
///< 渐变色layer
+ (CAGradientLayer *)colorGradientRampWithColorStart:(NSString *)colorStart alphaStart:(CGFloat)as colorEnd:(NSString *)colorEnd alphaEnd:(CGFloat)ae frame:(CGRect)frame;
+ (UIColor *)colorGradientChangeWithSize:(CGSize)size startColor:(UIColor *)startcolor endColor:(UIColor *)endColor; // 渐变色UIColor
+ (UIImage *)imageGradientChangeWithSize:(CGSize)size startColor:(UIColor *)startcolor endColor:(UIColor *)endColor; // 渐变色UIColor

+ (UIImage *)imageFromColors:(NSArray*)colors size:(CGSize)size; // 渐变色Image

@end

// 快捷调用
NS_INLINE UIColor * ColorFromRGB(uint32_t hex) {
    return [UIColor colorWithRGBHex:hex];
}

//
//  UIColor+CLHex.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

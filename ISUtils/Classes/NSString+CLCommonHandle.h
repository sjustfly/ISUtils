//
//  NSString+CLCommonHandle.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CLCommonHandle)

// 将汉字转换为拼音
- (NSString*)pinyin;
- (BOOL)isChinese;
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor;
 // 计算字体大小
 // @param font 字体
 // @param constrainedSize 容器尺寸
- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)constrainedSize;
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)constrainedWidth;
- (CGFloat)widthWithFont:(UIFont *)font constrainedHeight:(CGFloat)constrainedHeight;

/*
 *   传入高度和fontsize获取字符串size
 */
- (CGSize)getSizeWithHeight:(CGFloat)height font:(UIFont *)font;
/*
 *   传入宽度和fontsize获取字符串size
 */
- (CGSize)getSizeWithWidth:(CGFloat)width font:(UIFont *)font;

//  判断是否含有表情
- (BOOL)containsEmoji;

// 用@""替换掉表情字符
- (NSString *)removingEmoji;

//  去除空格
- (NSString *)trimmingWhitespace;
// @brief  去除空字符串与空行
- (NSString *)trimmingWhitespaceAndNewlines;

// JSON字符串转成NSDictionary
- (nullable id)jsonStringToObject;

+ (NSString *)formatFloat2Letter:(double)ft;
// 格式化长度， 超过用...代替
- (NSString *)formatLength:(NSUInteger)length;
// 格式化，并移除所有后边的0
+ (NSString *)removeFloatAllZero:(double)number;

// 四舍五入
// number:需要处理的数字，
// minimumFractionDigits：最少小数位，
// maximumFractionDigits：最大小数位
+ (NSString *)formatNumber:(double)number minimum:(NSUInteger)minimumFractionDigits maxnum:(NSUInteger)maximumFractionDigits;

- (NSDictionary *)toJsonDictionary;
- (NSArray *)toJsonArray;

/// 加减乘除
- (NSString *)decimalAdding:(NSString *)decimalString;
- (NSString *)decimalSubtracting:(NSString *)decimalString;
- (NSString *)decimalMultiplying:(NSString *)decimalString;
- (NSString *)decimalDividing:(NSString *)decimalString;


@end

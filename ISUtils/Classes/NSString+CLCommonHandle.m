//
//  NSString+CLCommonHandle.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "NSString+CLCommonHandle.h"

@implementation NSString (CLCommonHandle)

- (NSString *)pinyin {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
     //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

- (NSString *)firstCharactor {
    //转化为大写拼音
    NSString *pinYin = [self pinyin];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)constrainedSize {
    CGSize size = [self boundingRectWithSize:constrainedSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)constrainedWidth {
    return [self sizeWithFont:font constrainedSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)].height;
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedHeight:(CGFloat)constrainedHeight {
    return [self sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, constrainedHeight)].width;
}

- (BOOL)containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

- (NSString *)removingEmoji {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring containsEmoji])?(@""): substring];
                          }];
    
    return buffer;
}

- (NSString *)trimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmingWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSDictionary *)toJsonDictionary {
    return [self jsonStringToObject];
}

- (NSArray *)toJsonArray {
    return [self jsonStringToObject];
}


- (nullable id)jsonStringToObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSError *err;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return object;
}

+ (NSString *)formatFloat2Letter:(double)ft {
    if (fmodl(ft, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",ft];
    } else if (fmodl(ft*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",ft];
    } else {
        return [NSString stringWithFormat:@"%.2f",ft];
    }
}

- (NSString *)formatLength:(NSUInteger)length {
    if (length == 0 || self.length <= length) {
        return self;
    }
    NSString *s = [self substringToIndex:length];
    return [NSString stringWithFormat:@"%@...",s];
}

+ (NSString *)removeFloatAllZero:(double)number {
    return [NSString stringWithFormat:@"%@",@(number)];
}

+ (NSString *)formatNumber:(double)number minimum:(NSUInteger)minimumFractionDigits maxnum:(NSUInteger)maximumFractionDigits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumFractionDigits = minimumFractionDigits;
    numberFormatter.maximumFractionDigits = maximumFractionDigits;
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

@end
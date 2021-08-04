//
//  NSString+CLCommonRegex.h
//  CLKitDemo
//
//  Created by plus on 2017/10/15.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 主要用于过滤作用
UIKIT_EXTERN NSString *const nonNameRegex; // 中文字母数字
UIKIT_EXTERN NSString *const nonUsernameRegex; // 字母数字
UIKIT_EXTERN NSString *const nonPureNumberRegex; // 数字
UIKIT_EXTERN NSString *const emojiRegex; // 表情

@interface NSString (CLCommonRegex)

- (BOOL)isNumberLetter;
- (BOOL)isPureNumber;
- (BOOL)isEmail;
- (BOOL)isURL;
- (BOOL)isMobile;
- (BOOL)isTelephone;
- (BOOL)isIdentityNumber; // 身份证
- (BOOL)isRealText; // 有真实文字
- (BOOL)isValidPassword;
- (BOOL)isValidPrice;
- (BOOL)isValidJudgePrice;
- (BOOL)isContainsEmoji;
- (BOOL)isValidRegex:(NSString *)regex;
- (NSString *)replaceRegexString:(NSString *)regex withString:(NSString *)replace;

@end

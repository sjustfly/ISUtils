//
//  NSString+CLCommonRegex.m
//  CLKitDemo
//
//  Created by plus on 2017/10/15.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "NSString+CLCommonRegex.h"

NSString *const nonNameRegex = @"[^\u4E00-\u9FA5A-Za-z0-9]";
NSString *const nonUsernameRegex = @"[^A-Za-z0-9]";
NSString *const nonPureNumberRegex = @"[^0-9]";
NSString *const emojiRegex = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";

@implementation NSString (CLCommonRegex)

- (BOOL)isNumberLetter {
    static NSString *const numberLetterRegex = @"^[a-zA-Z0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberLetterRegex];
    return [test evaluateWithObject:self];
}

- (BOOL)isPureNumber
{
    static NSString *const numberRegex = @"^[0-9]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isEmail
{
    static NSString *const emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isURL
{
    static NSString *const urlRegex =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isMobile {
    /**
      *  Mobile
      *
      */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-3,5-9]|6[6]|7[0135678]|8[0-9]|9[89])\\d{8}$";

    /**
      * 中国移动：China Mobile
      * 134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,183,187,188,195,198[0-9]
      */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[017-9]|8[2378]|9[58])\\d)\\d{7}$";
    /**
      * 中国联通：China Unicom
      * 130,131,132.145,152,155,156,176,185,186，166[0-9]
      */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|7[6]|8[56]|6[6])\\d{8}$";
    /**
      * 中国电信：China Telecom
      * 133,1349,177,153,180,181,189,199[0-9]
      */
    NSString * CT = @"^1((33|53|77|8[019]|9[9])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isIdentityNumber
{
    static NSString *const phoneRegex = @"^([0-9]{17}[0-9X]{1})|([0-9]{15})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isTelephone
{
    static NSString *const phoneRegex = @"^\\d{3}-{0,1}\\d{8}|\\d{4}-{0,1}\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isRealText
{
    if (self.length == 0) {
        return NO;
    }
    static NSString *const blankRegex = @"^[\f\n\r\t\v ]{0,}$";
    NSPredicate *blankTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",blankRegex];
    return [blankTest evaluateWithObject:self] ? NO : YES;
}

- (BOOL)isValidPassword {
    static NSString *const pwdRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdTest evaluateWithObject:self];
}

- (BOOL)isValidPrice {
    static NSString *const dotRegex = @"^\\d{1,10}(\\.\\d{1,2})?$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dotRegex];
    return [pwdTest evaluateWithObject:self];
}

- (BOOL)isValidJudgePrice {
    static NSString *const dotRegex = @"^\\d{1,4}(\\.\\d{1})?$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dotRegex];
    return [pwdTest evaluateWithObject:self];
}

- (BOOL)isContainsEmoji {
    return [self isValidRegex:emojiRegex];
}

- (NSString *)replaceEmojiWithString:(NSString *)replace {
    return [self replaceRegexString:emojiRegex withString:replace];
}

- (BOOL)isValidRegex:(NSString *)regex {
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger num = [re numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return num > 0 ? YES : NO;
}

- (NSString *)replaceRegexString:(NSString *)regex withString:(NSString *)replace {
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [re stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replace];
    return modifiedString;
}

@end

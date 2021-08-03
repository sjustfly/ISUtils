//
//  UITextField+CLCharacterFilter.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/25.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^CLDynamicValidateCharactersBlock)(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string, NSString *_Nonnull shoud);

@interface UITextField (CLCharacterFilter)<UITextFieldDelegate>

// 有限制的设置文本
// 会限制小数点长度，如果不满足有理数格式，不起作用，如果是55. 没有x小数点后面的字，不受影响
- (void)setText:(NSString *)text allowDecimalCount:(NSInteger)decimalCount;
/** 统计限制字数长度*/
@property (nonatomic, assign) NSUInteger maxLength;

// 用来过滤字符的正则表达式，如果是满足正则表达式的字符，会被替换过掉
@property(nonatomic, nullable, strong) NSString *filterRegex;

// 将 shouldChangeCharactersBlock 配置为过滤字符
- (void)configValidatorRegex:(NSString * _Nonnull)regex;

// 能否改变字符, 动态验证的block，但是在输入中文的时候，有标记项，不能获取是否有标记项，如果设置， 优先级高于 filterRegex
@property(nonatomic, nullable, copy) CLDynamicValidateCharactersBlock shouldChangeCharactersBlock;

//  折扣 0~1折扣
+ (nonnull CLDynamicValidateCharactersBlock)discountValiditorWithDecimalCount:(NSInteger)decimalCount;

// 整数位数， 小数位数 例如 最多2个整数3位小数 不能为负数
+ (nonnull CLDynamicValidateCharactersBlock)validitorPosivitiveWithIntegerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount;
// 整数位数， 小数位数 例如 最多2个整数3位小数, 可以为负数
+ (nonnull CLDynamicValidateCharactersBlock)validitorNumberWithIntegerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount;

+ (nonnull CLDynamicValidateCharactersBlock)validitorNumber:(BOOL)allowNegative integerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount ignorePrefix:(NSString *)prefix ignoreSuffix:(NSString *)suffix;

@end


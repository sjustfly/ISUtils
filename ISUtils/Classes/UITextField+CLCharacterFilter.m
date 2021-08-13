//
//  UITextField+CLCharacterFilter.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/25.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UITextField+CLCharacterFilter.h"
#import <objc/runtime.h>
#import "UIView+CLShaker.h"
#import "NSString+CLCommonRegex.h"
#import "MethodSwizzle.h"

static char filterRegexKey;
static char filterAddObserverKey;

static char filterShouldChangeKey;
static char maxLengthKey;

@implementation UITextField (CLCharacterFilter)

+ (void)load {
    SwizzleMethod(self, NSSelectorFromString(@"dealloc"), @selector(zwCharacterFilter_swizzled_dealloc));
    SwizzleMethod(self, @selector(setDelegate:), @selector(swizzle_setDelegate:));
    SwizzleMethod(self, @selector(delegate), @selector(swizzle_delegate));
}

#pragma mark - filterCharacter

- (nullable NSString *)filterRegex {
    return objc_getAssociatedObject(self, &filterRegexKey);
}

- (void)setFilterRegex:(NSString *)filterRegex {
    [self filterAddObserve];
    objc_setAssociatedObject(self, &filterRegexKey, filterRegex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zwCharacterFilter_swizzled_dealloc {
    NSLog(@"zwCharacterFilter_swizzled_dealloc %@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setInnerDelegate:nil];
    [self zwCharacterFilter_swizzled_dealloc];
}

- (void)filterAddObserve {
    NSNumber *observer = objc_getAssociatedObject(self, &filterAddObserverKey);
    if (!observer) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterTextFieldEditChanged:)
                                                     name:UITextFieldTextDidChangeNotification object:self];
        objc_setAssociatedObject(self, &filterAddObserverKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - update

- (void)filterTextFieldEditChanged:(NSNotification *)notification {
    UITextRange *markedRange = [self markedTextRange];
    if (markedRange) {
        return;
    }
    if (self.maxLength > 0 && self.text.length > self.maxLength) {
        self.text = [self.text substringToIndex:self.maxLength];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
        [self shake];
        return;
    }
    if (self.filterRegex) {
        if ([self.text isValidRegex:self.filterRegex]) {
            self.text = [self.text replaceRegexString:self.filterRegex withString:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
            [self shake];
        }
    }
}

- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &maxLengthKey) unsignedIntegerValue];
}

- (void)setMaxLength:(NSUInteger)maxLength {
    [self filterAddObserve];
    objc_setAssociatedObject(self, &maxLengthKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setText:(NSString *)text allowDecimalCount:(NSInteger)decimalCount {
    if (decimalCount < 0 || text.length == 0) {
        self.text = text;
        return;
    }
    NSString *regex = @"^(\\-?)(\\d+(\\.)?(\\d+)?)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [predicate evaluateWithObject:text];
    if (!result) { // 非正确的有理数格式
        self.text = text;
        return;
    }
    BOOL isHaveDian = YES;
    if ([text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if (!isHaveDian) {
        self.text = text;
        return;
    }
    NSArray *tmp = [text componentsSeparatedByString:@"."];
    if (tmp.count != 2) {
        self.text = text;
        return;
    }
    NSString *dec = tmp[1];
    if (dec.length > decimalCount) {
        dec = [dec substringToIndex:decimalCount];
    }
    NSMutableArray *fin = [NSMutableArray array];
    [fin addObject:tmp.firstObject];
    [fin addObject:dec?:@""];
    self.text = [fin componentsJoinedByString:@"."];
}

#pragma mark - CLDynamicValidateCharactersBlock

- (void)swizzle_setDelegate:(id<UITextFieldDelegate>)delegate {
    if (delegate) {
        if (delegate == self) {
            [self swizzle_setDelegate:delegate];
            [self setInnerDelegate:nil];
        } else {
            [self swizzle_setDelegate:self];
            [self setInnerDelegate:delegate];
        }
    } else {
        [self swizzle_setDelegate:nil];
        [self setInnerDelegate:nil];
    }
}

- (id<UITextFieldDelegate>)swizzle_delegate {
    return self.innerDelegate;
}

/*
 所有代理必须重新写一遍
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [innerDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [innerDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [innerDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [innerDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(NSInteger)reason  {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [innerDelegate textFieldDidEndEditing:textField reason:reason];
    } else if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [innerDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL should = YES;
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        should = [innerDelegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    NSMutableString *pre = [[NSMutableString alloc] initWithString:textField.text?:@""];
    NSInteger maxLength = range.location + range.length;
    if (pre.length >= maxLength) {
        [pre replaceCharactersInRange:range withString:string?:@""];
    } else {
        return NO;
    }
    if (self.shouldChangeCharactersBlock) {
        should = should && self.shouldChangeCharactersBlock(self, range, string, pre);
    }
    if (!should) {
        [self shake];
    }
    return should;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldDidChangeSelection:)]) {
        [innerDelegate textFieldDidChangeSelection:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [innerDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    id innerDelegate = self.innerDelegate;
    if (innerDelegate && [innerDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [innerDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

- (void)setInnerDelegate:(id<UITextFieldDelegate>)delegate {
    if (!delegate) {
        objc_setAssociatedObject(self, @selector(innerDelegate), nil, OBJC_ASSOCIATION_ASSIGN);
    } else {
        objc_setAssociatedObject(self, @selector(innerDelegate), delegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (id<UITextFieldDelegate>)innerDelegate {
    return objc_getAssociatedObject(self, @selector(innerDelegate));
}

- (void)setShouldChangeCharactersBlock:(CLDynamicValidateCharactersBlock)shouldChangeCharactersBlock {
    [self swizzle_setDelegate:self];
    objc_setAssociatedObject(self, &filterShouldChangeKey, shouldChangeCharactersBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CLDynamicValidateCharactersBlock)shouldChangeCharactersBlock {
    return objc_getAssociatedObject(self, &filterShouldChangeKey);
}

- (void)configValidatorRegex:(NSString * _Nonnull)regex {
    if (regex.length) {
        [self setShouldChangeCharactersBlock:^BOOL(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string, NSString * _Nonnull shoud) {
            NSError *error;
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
            if (error) { return YES; }
            return ![regular firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        }];
    } else {
        [self setShouldChangeCharactersBlock:nil];
    }
}

+ (nonnull CLDynamicValidateCharactersBlock)discountValiditorWithDecimalCount:(NSInteger)decimalCount {
    CLDynamicValidateCharactersBlock block = ^BOOL(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string, NSString * _Nonnull shoud) {
        if (string.length == 0 || shoud.length == 0 || [shoud isEqualToString:@"0."] || [shoud isEqualToString:@"1."] || [shoud isEqualToString:@"0"] || [shoud isEqualToString:@"1"]) {
            return YES;
        }
        NSString *regex = [NSString stringWithFormat:@"^(0(\\.\\d{1,%ld})?|1(\\.0{1,%ld})?)$", decimalCount, decimalCount];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pred evaluateWithObject:shoud];
    };
    return block;
}

+ (nonnull CLDynamicValidateCharactersBlock)validitorNumber:(BOOL)allowNegative integerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount ignorePrefix:(NSString *)prefix ignoreSuffix:(NSString *)suffix {
    CLDynamicValidateCharactersBlock block = ^BOOL(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string, NSString * _Nonnull shoud) {
        if (string.length == 0) {
            return YES;
        }
        NSString *content = shoud;
        NSString *tfcontent = textField.text;
        if (prefix.length && [content hasPrefix:prefix]) {
            content = [content substringFromIndex:prefix.length];
        }
        if (suffix.length && [content hasSuffix:suffix]) {
            content = [content substringToIndex:content.length-suffix.length];
        }
        if (prefix.length && [tfcontent hasPrefix:prefix]) {
            tfcontent = [tfcontent substringFromIndex:prefix.length];
        }
        if (suffix.length && [tfcontent hasSuffix:suffix]) {
            tfcontent = [tfcontent substringToIndex:tfcontent.length-suffix.length];
        }
        if (integerCount == 0 && decimalCount == 0) {
            return YES;
        }
        if (content.length == 0) {
            return YES;
        }
        NSString *regex = @"^\\d+(\\.)?(\\d+)?$";
        if (allowNegative) {
            regex = @"^(\\-?)(\\d+(\\.)?(\\d+)?)?$";
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL result = [predicate evaluateWithObject:content];
        if (!result) {
            return NO;
        }
        NSInteger isHaveNeg = [tfcontent containsString:@"-"]?1:0;
        // 限制只能输入数字
        BOOL isHaveDian = YES;
        if ([tfcontent rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if (!isHaveDian && content.length > (integerCount+isHaveNeg) && single != '.') {
                return NO;
            }
            if([content length] == 0){ // ?
                if(single == '.') {
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian) {//text中还没有小数点
                    isHaveDian = YES;
                    return YES;
                } else {
                    return NO;
                }
            } else {
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    NSInteger num = range.location - ran.location;
                    if (num <= decimalCount && ran.location <= (integerCount+isHaveNeg)) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {
            return YES;
        }
    };
    return block;
}

+ (nonnull CLDynamicValidateCharactersBlock)validitorPosivitiveWithIntegerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount {
    return [self validitorNumber:NO integerCount:integerCount decimalCount:decimalCount ignorePrefix:@"" ignoreSuffix:@""];
}

+ (nonnull CLDynamicValidateCharactersBlock)validitorNumberWithIntegerCount:(NSInteger)integerCount decimalCount:(NSInteger)decimalCount {
    return [self validitorNumber:YES integerCount:integerCount decimalCount:decimalCount ignorePrefix:@"" ignoreSuffix:@""];
}

@end

//
//  NSObject+Null.m
//  MobileGjp
//
//  Created by chao luo on 4/26/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

@end

@implementation  NSNumber (Decimal)

- (NSNumber *)reviseDecimalNumber {
    // 整型则直接返回
    if ([self integerValue] == [self doubleValue]) {
        return self;
    }
    double doubleConversionValue = [self doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleConversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber;
}

@end

@implementation NSArray (Decimal)

// 修改正浮点数精度问题
- (NSArray *)reviseDecimalNumber {
    NSMutableArray *tmp = [NSMutableArray array];
    for (id item in self) {
        if ([item isKindOfClass:NSNumber.class]) {
            [tmp addObject:[((NSNumber *)item) reviseDecimalNumber]];
        } else if ([item isKindOfClass:NSDictionary.class]) {
            [tmp addObject:[((NSDictionary *)item) reviseDecimalNumber]];
        } else if ([item isKindOfClass:NSArray.class]) {
            [tmp addObject:[((NSArray *)item) reviseDecimalNumber]];
        } else {
            [tmp addObject:item];
        }
    }
    return [tmp copy];
}

@end

@implementation NSDictionary (Decimal)

// 修改正浮点数精度问题
- (NSDictionary *)reviseDecimalNumber {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id key in self.allKeys) {
        id item = self[key];
        if ([item isKindOfClass:NSNumber.class]) {
            [dic setObject:[((NSNumber *)item) reviseDecimalNumber] forKey:key];
        } else if ([item isKindOfClass:NSDictionary.class]) {
            [dic setObject:[((NSDictionary *)item) reviseDecimalNumber] forKey:key];
        } else if ([item isKindOfClass:NSArray.class]) {
            [dic setObject:[((NSArray *)item) reviseDecimalNumber] forKey:key];
        } else {
            [dic setObject:item forKey:key];
        }
    }
    return dic;
}

@end

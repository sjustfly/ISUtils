//
//  NSObject+Null.h
//  MobileGjp
//
//  Created by chao luo on 4/26/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define IsDeciamlEqualDefault(d1, d2) IsDeciamlEqual(d1, d2, 0.00001) // 系统最长只有5位

NS_INLINE BOOL IsDeciamlEqual(double d1, double d2, float EPSILON) {
    if (fabs(d1 - d2) < EPSILON) {
        return YES;
    }
    return NO;
}

NS_INLINE NSString *NullToString(id object) {
    if (!object) {
        return @"";
    }
    if (object == [NSNull null]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", object];
}

// 将nil转换为null
NS_INLINE id NilToNull(id object) {
    return object ?: [NSNull null];
}

// 将null转换为nil
NS_INLINE _Nullable id NullToNil(id object) {
    if ([object isEqual:[NSNull null]]) {
        return nil;
    }
    return object;
}

@interface NSObject (Null)

@end

@interface NSNumber (Decimal)

// 修改正浮点数精度问题
- (NSNumber *)reviseDecimalNumber;

@end

@interface NSArray (Decimal)

// 修改正浮点数精度问题
- (NSArray *)reviseDecimalNumber;

@end

@interface NSDictionary (Decimal)

// 修改正浮点数精度问题
- (NSDictionary *)reviseDecimalNumber;

@end

NS_ASSUME_NONNULL_END

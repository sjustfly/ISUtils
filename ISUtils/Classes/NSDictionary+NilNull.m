//
//  NSDictionary+NilNull.m
//  MobilePrinter
//
//  Created by fang liao on 2019/7/10.
//  Copyright © 2019 fang liao. All rights reserved.
//

#import "NSDictionary+NilNull.h"

@implementation NSDictionary (NilNull)

- (BOOL)boolForKey:(id<NSCopying>)aKey {
    id data = [self objectNullToNilForKey:aKey];
    return [data boolValue];
}

- (double)doubleForKey:(id<NSCopying>)aKey {
    id data = [self objectNullToNilForKey:aKey];
    return [data doubleValue];
}

- (NSInteger)integerForKey:(id<NSCopying>)aKey {
    id data = [self objectNullToNilForKey:aKey];
    return [data integerValue];
}

- (int64_t)int64ForKey:(id<NSCopying>)aKey {
    id data = [self objectNullToNilForKey:aKey];
    return [data longValue];
}

- (NSString *)stringForKey:(id<NSCopying>)aKey {
    id data = [self objectNullToNilForKey:aKey];
    return data ? [NSString stringWithFormat:@"%@", data] : nil;
}

- (id)objectNullToNilForKey:(id<NSCopying>)aKey {
    id data = [self objectForKey:aKey];
    if ([data isEqual:[NSNull null]]) {
        return nil;
    }
    return data;
}

@end

@implementation NSMutableDictionary (NilNull)

- (void)setObjectIgnoreNil:(id)object forKey:(id<NSCopying>)aKey {
    if (!object || !aKey) {
        return;
    }
    [self setObject:object forKey:aKey];
}

- (void)setObjectNilToNull:(id)object forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    id data = object ? : [NSNull null];
    [self setObject:data forKey:aKey];
}

@end

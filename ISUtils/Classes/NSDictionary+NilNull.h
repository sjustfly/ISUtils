//
//  NSDictionary+NilNull.h
//  MobilePrinter
//
//  Created by fang liao on 2019/7/10.
//  Copyright © 2019 fang liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSEnumerator.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NilNull)

- (BOOL)boolForKey:(id<NSCopying>)aKey;
- (double)doubleForKey:(id<NSCopying>)aKey;
- (NSInteger)integerForKey:(id<NSCopying>)aKey;
- (NSString *)stringForKey:(id<NSCopying>)aKey;
- (id)objectNullToNilForKey:(id<NSCopying>)aKey;

@end

@interface NSMutableDictionary (NilNull)
// 如果object == nil 跳过
- (void)setObjectIgnoreNil:(id)object forKey:(id<NSCopying>)aKey;
// 如果 object == nil 转换为null 上传
- (void)setObjectNilToNull:(id)object forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END

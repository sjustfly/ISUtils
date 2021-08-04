//
//  MutableOrderedDictionary.m
//
//  Created by Heitor Ferreira on 9/21/12.
//
//

#import "CLMutableOrderedDictionary.h"

@interface CLMutableOrderedDictionary ()
@property(nonatomic,strong) NSMutableArray *innerOrderedKeys;
@property(nonatomic,strong) NSMutableDictionary *store;
@property(nonatomic,assign) NSUInteger hashValue;
@end

@implementation CLMutableOrderedDictionary

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization
////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CLMutableOrderedDictionary *)dictionaryWithCapacity:(NSUInteger)capacity
{
    return [[CLMutableOrderedDictionary alloc] initWithCapacity:capacity];
}

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
    if(self = [super init]) {
        _innerOrderedKeys = [NSMutableArray arrayWithCapacity:capacity];
        _store = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Access
////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)count
{
    return [self.innerOrderedKeys count];
}

- (BOOL)containsKey:(id<NSCopying>)aKey
{
    return ([self.store objectForKey:aKey] != nil);
}

- (NSArray *)allValues
{
    return [self.store allValues];
}

- (NSArray *)orderedValues
{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.store.count];
    [self.innerOrderedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [values addObject:[self.store objectForKey:obj]];
    }];
    return [values copy];
}


- (NSDictionary*)dictionary
{
    return [self.store copy];
}

- (NSEnumerator *)keyEnumerator
{
    return self.innerOrderedKeys.objectEnumerator;
}

- (NSArray *)orderedKeys
{
    return [self.innerOrderedKeys copy];
}

- (NSSet *)keySet
{
    return [NSSet setWithArray:self.innerOrderedKeys];
}

- (void)sortedOrderedKeysUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    self.innerOrderedKeys = [[self.innerOrderedKeys sortedArrayUsingComparator:cmptr] mutableCopy];
};

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForKey:(id)aKey
{
    return [self.store objectForKey:aKey];
}

- (id)objectForKeyedSubscript:(id)aKey
{
    return [self.store objectForKey:aKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectAtIndex:(NSUInteger)index
{
    return [self.store objectForKey:[self.innerOrderedKeys objectAtIndex:index]];
}

- (id)objectAtIndexedSubscript:(NSInteger)index
{
    return [self objectAtIndex:index];
}

- (void)insetObject:(id)anObject forKey:(id<NSCopying>)aKey beforeKey:(id<NSCopying>)beforeKey {
    if ([self containsKey:aKey]) {
        [self setObject:anObject forKey:aKey];
        return;
    }
    NSUInteger index = [self.innerOrderedKeys indexOfObject:beforeKey];
    [self.innerOrderedKeys insertObject:aKey atIndex:index];
    [self.store setObject:anObject forKey:aKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutation
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if(![self.store objectForKey:aKey]) {
        [self.innerOrderedKeys addObject:aKey];
    }
    [self.store setObject:anObject forKey:aKey];
}

- (void)setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey
{
    [self setObject:anObject forKey:aKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeObjectForKey:(id<NSCopying>)aKey
{
    if([self.store objectForKey:aKey] != nil) {
        [self.store removeObjectForKey:aKey];
        [self.innerOrderedKeys removeObject:aKey];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    id key = [self.innerOrderedKeys objectAtIndex:index];
    if(key) {
        [self.innerOrderedKeys removeObjectAtIndex:index];
        [self.store removeObjectForKey:key];
    }

}

- (void)removeAllObjects
{
    [self.store removeAllObjects];
    [self.innerOrderedKeys removeAllObjects];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSMutableCopying
////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)mutableCopyWithZone:(NSZone *)zone
{
    CLMutableOrderedDictionary *copy = [[CLMutableOrderedDictionary allocWithZone:zone] init];
    copy.store = [self.store mutableCopyWithZone:zone];
    copy.innerOrderedKeys = [self.innerOrderedKeys mutableCopyWithZone:zone];
    return copy;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFastEnumeration
//////////////////////////////////////////////////////////////////////////////////////////////////// 
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [self.innerOrderedKeys countByEnumeratingWithState:state objects:buffer count:len];
}
//
///// 用来判断是否一样
//- (NSUInteger)hash {
//    NSUInteger h = 0;
//    for (NSObject *key in self.orderedKeys) {
//        NSObject *obj = [self objectForKey:key];
//        h = h ^ [key hash] ^ [obj hash];
//    }
//    return h;
//}

@end

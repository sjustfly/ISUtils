//
//  View+MASExpanded.m
//  SAX_iOS
//
//  Created by 普拉斯 on 2017/10/10.
//  Copyright © 2017年 dftc. All rights reserved.
//

#import "View+MASExpanded.h"

@implementation MAS_VIEW (MASExpanded)

- (NSArray *)mass_makeConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:self];
    if (nil != block) {
        block(constraintMaker, self.superview);
    }
    return [constraintMaker install];
}

- (NSArray *)mass_updateConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    if (nil != block) {
        block(constraintMaker, self.superview);
    }
    return [constraintMaker install];
}

- (NSArray *)mass_remakeConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    if (nil != block) {
        block(constraintMaker, self.superview);
    }
    return [constraintMaker install];
}


@end

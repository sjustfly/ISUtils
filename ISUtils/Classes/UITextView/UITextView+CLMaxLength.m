//
//  UITextView+CLMaxLength.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UITextView+CLMaxLength.h"
#import "NSString+CLCommonRegex.h"
#import <objc/runtime.h>
#import "UIView+Additions.h"
#import "MethodSwizzle.h"
#import "UIView+CLShaker.h"

#define inputLabelTailing 10
#define inputLabelHeight 15

static char tvFilterRegexKey;
static char inputLimitKey;
static char addObserverKey;

@implementation UITextView (CLMaxLength)

+ (void)load {
    SwizzleMethod(self.class, NSSelectorFromString(@"drawRect:"), @selector(maxLength_swizzling_drawRect:));
}

#pragma mark - swizzled
- (void)maxLength_swizzled_dealloc {
    if (objc_getAssociatedObject(self, &addObserverKey)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    }
    [self maxLength_swizzled_dealloc];
}

- (nullable NSString *)filterRegex {
    return objc_getAssociatedObject(self, &tvFilterRegexKey);
}

- (void)setFilterRegex:(NSString *)filterRegex {
    [self addObserverIfNeeded];
    objc_setAssociatedObject(self, &tvFilterRegexKey, filterRegex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)maxLength_swizzling_drawRect:(CGRect)rect {
    [self maxLength_swizzling_drawRect:rect];
    if (self.maxLength > 0 && self.text.length > 0) {
        NSString *text = [NSString stringWithFormat:@"%zd/%zd",self.text.length,self.maxLength];
        CGRect r = CGRectMake(0, rect.size.height - 13, rect.size.width-8, 12);
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:11],
                            NSParagraphStyleAttributeName: paragraphStyle,
                            NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        [text drawInRect:r withAttributes:attributes];
    }
}

#pragma mark - associated

- (void)addObserverIfNeeded {
    if (!objc_getAssociatedObject(self, &addObserverKey)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeCharacter:) name:UITextViewTextDidChangeNotification object:self];
        objc_setAssociatedObject(self, &addObserverKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)textViewDidChangeCharacter:(NSNotification *)notify {
    if (notify.object == self) {
        [self updateLimitCount];
        [self setNeedsDisplay];
    }
}

- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &inputLimitKey) unsignedIntegerValue];
}

- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &inputLimitKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maxLength > 0) {
        self.contentInset = UIEdgeInsetsMake(0, 0, inputLabelHeight, 0);
        [self addObserverIfNeeded];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - update
- (void)updateLimitCount {
    if (self.maxLength <= 0) return;
    if (self.text.length > self.maxLength) {
        UITextRange *markedRange = [self markedTextRange];
        if (!markedRange || [markedRange isEmpty]) {
            self.text = [self.text substringToIndex:self.maxLength];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
        }
    }
    if (self.filterRegex) {
        if ([self.text isValidRegex:self.filterRegex]) {
            self.text = [self.text replaceRegexString:self.filterRegex withString:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
            [self shake];
        }
    }
}

@end


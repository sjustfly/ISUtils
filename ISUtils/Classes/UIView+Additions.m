//
//  UIViewAdditions.m
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Additions.h"
#import "MethodSwizzle.h"

@implementation UIView (CLEdgeAdditions)

+ (void)load {
    SwizzleMethod(self, NSSelectorFromString(@"intrinsicContentSize"), @selector(swizzle_intrinsicContentSize));
    SwizzleMethod(self, NSSelectorFromString(@"sizeToFit"), @selector(swizzle_sizeToFit));
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [borderColor CGColor];
}

- (UIViewController *)viewController {
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

- (UIView *)setTopBorderColor:(UIColor *)color {
    return [self setTopBorderColor:color insets:UIEdgeInsetsZero constant:0.5];
}

- (UIView *)setTopBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeTop magrin:insets.top];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeLeft magrin:insets.left];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeRight magrin:-insets.right];
    [self addFixedSizeConstraintWithItem:line attribute:NSLayoutAttributeHeight constant:0.5];
    return line;
}

- (UIView *)setBottomBorderColor:(UIColor *)color {
    return [self setBottomBorderColor:color insets:UIEdgeInsetsZero constant:0.5];
}

- (UIView *)setBottomBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeBottom magrin:insets.bottom];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeLeft magrin:insets.left];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeRight magrin:-insets.right];
    [self addFixedSizeConstraintWithItem:line attribute:NSLayoutAttributeHeight constant:constant];
    return line;
}

- (UIView *)setRightBorderColor:(UIColor *)color {
    return [self setRightBorderColor:color insets:UIEdgeInsetsZero constant:0.5];
}

- (UIView *)setRightBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeTop magrin:insets.top];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeBottom magrin:-insets.bottom];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeRight magrin:insets.right];
    [self addFixedSizeConstraintWithItem:line attribute:NSLayoutAttributeWidth constant:constant];
    return line;
}

- (UIView *)setLeftBorderColor:(UIColor *)color {
    return [self setLeftBorderColor:color insets:UIEdgeInsetsZero constant:0.5];
}

- (UIView *)setLeftBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeTop magrin:insets.top];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeBottom magrin:-insets.bottom];
    [self addPositionConstraintWithItem:line attribute:NSLayoutAttributeLeft magrin:insets.left];
    [self addFixedSizeConstraintWithItem:line attribute:NSLayoutAttributeWidth constant:constant];
    return line;
}

- (void)addPositionConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attribute magrin:(CGFloat)magrin {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:1.0 constant:magrin];
    [self addConstraint:constraint];
}

- (void)addFixedSizeConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
    [self addConstraint:constraint];
}

- (void)setManualIntrinsicContentSize:(CGSize)manualIntrinsicContentSize {
    NSValue *value = [NSValue valueWithCGSize:manualIntrinsicContentSize];
    objc_setAssociatedObject(self, @selector(manualIntrinsicContentSize), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)manualIntrinsicContentSize {
    NSValue *value = objc_getAssociatedObject(self, @selector(manualIntrinsicContentSize));
    return [value CGSizeValue];
}

- (CGSize)swizzle_intrinsicContentSize {
    if (CGSizeEqualToSize(self.manualIntrinsicContentSize, CGSizeZero)) {
        return [self swizzle_intrinsicContentSize];
    }
    return self.manualIntrinsicContentSize;
}

- (void)swizzle_sizeToFit {
    if (CGSizeEqualToSize(CGSizeZero, self.manualIntrinsicContentSize)) {
        [self swizzle_sizeToFit];
    } else {
        self.size = self.manualIntrinsicContentSize;
    }
}

- (void)addTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (UIView *)firstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view firstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}

@end

@implementation CALayer (Additions)

/******************************设置View左边x坐标*******************************/
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/****************************设置View顶部y坐标*********************************/
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/****************************设置View右边x坐标*********************************/
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

/****************************设置View底部y坐标*************************************/
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/*****************************设置View的中心坐标********************************/
- (CGFloat)centerX {
    return self.position.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.position = CGPointMake(centerX, self.position.y);
}

- (CGFloat)centerY {
    return self.position.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.position = CGPointMake(self.position.x, centerY);
}

/**************************设置View的宽度***********************************/
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/*****************************设置View的高度********************************/
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end

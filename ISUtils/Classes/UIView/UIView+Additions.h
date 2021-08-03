//
//  UIViewAdditions.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CLEdgeAdditions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) UIColor *borderColor;

// The view controller whose view contains this view.
@property (nonatomic, readonly) UIViewController *viewController;

- (UIView *)setTopBorderColor:(UIColor *)color;
- (UIView *)setTopBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant; // only top left right effect
- (UIView *)setBottomBorderColor:(UIColor *)color;
- (UIView *)setBottomBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant; // only bottom left right effect
- (UIView *)setRightBorderColor:(UIColor *)color;
- (UIView *)setRightBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant; // only top bottom right effect
- (UIView *)setLeftBorderColor:(UIColor *)color;
- (UIView *)setLeftBorderColor:(UIColor *)color insets:(UIEdgeInsets)insets constant:(CGFloat)constant; // only top left bottom effect

// 手动设置内容大小, 设置以后intrinsicContentSize 加上该大小
@property (nonatomic) CGSize manualIntrinsicContentSize;
// 递归寻找第一响应者
- (UIView *)firstResponder;

@end

@interface CALayer (Additions)

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@end

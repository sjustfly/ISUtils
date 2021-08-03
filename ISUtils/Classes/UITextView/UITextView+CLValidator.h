//
//  UITextView+CLValidator.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^TestBlock1)(UITextView *textView);
typedef void (^FailureBlock1)(NSString *message);

@interface UITextView (CLValidator)

// 添加验证的错误信息和验证Block
- (void)addFailureMessage:(NSString *)message testBlock:(TestBlock1)block;
// 重置验证器
- (void)resetValidator;
// 验证错误回调
- (void)setValidatorFailureBlock:(FailureBlock1)failure;
// 验证
- (BOOL)validate;
// 批量验证
+ (BOOL)validateTextViews:(NSArray <UITextView *>*)textViews failureBlock:(FailureBlock1)failure;

@end

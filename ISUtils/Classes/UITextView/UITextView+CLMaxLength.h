//
//  UITextView+CLMaxLength.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (CLMaxLength)

/** 统计限制字数*/
@property (nonatomic, assign) NSUInteger maxLength;
// 用来过滤字符的正则表达式，如果是满足正则表达式的字符，会被替换过掉
@property(nonatomic, nullable, strong) NSString *filterRegex;

@end

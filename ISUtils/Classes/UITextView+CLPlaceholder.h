//
//  UITextView+CLPlaceholder.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CLTextViewProxy;
@protocol CLTextViewProxyDelegate <NSObject>
@optional;
- (void)textViewProxy:(CLTextViewProxy *)proxy textViewDidChange:(UITextView *)textView;
@end

@interface CLTextViewProxy : NSObject
@property(nonatomic, weak) id<CLTextViewProxyDelegate>delegate;
- (void)textViewDidChange:(NSNotification *)notify;
@end

@interface UITextView (CLPlaceholder)<CLTextViewProxyDelegate>

// placeholder
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, strong) UIFont *placeholderFont;
@property(nonatomic, strong) UIColor *placeholderColor;
@property(nonatomic, strong) NSAttributedString *attributePlaceholder;

@end

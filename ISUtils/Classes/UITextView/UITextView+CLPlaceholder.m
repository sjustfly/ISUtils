//
//  UITextView+CLPlaceholder.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UITextView+CLPlaceholder.h"
#import <objc/runtime.h>

@implementation CLTextViewProxy

- (void)textViewDidChange:(NSNotification *)notify {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewProxy:textViewDidChange:)]) {
        [self.delegate textViewProxy:self textViewDidChange:notify.object];
    }
}

@end

#define kTopY 7.0
#define kLeftX 5.0

static char placeholderStringKey;
static char placeholderLabelKey;
static char attplaceholderStringKey;
static char textViewProxyKey;

@implementation UITextView (CLPlaceholder)
@dynamic placeholderColor;

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(placeholder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(placeholder_swizzled_dealloc)));
}

#pragma mark - swizzled
- (void)placeholder_swizzled_dealloc {
    if (objc_getAssociatedObject(self, &placeholderLabelKey)) {
        [[NSNotificationCenter defaultCenter] removeObserver:[self textViewProxy]];
        [self removeObserver:self forKeyPath:@"text"];
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    }
    [self placeholder_swizzled_dealloc];
}

- (CLTextViewProxy *)textViewProxy {
    CLTextViewProxy *proxy = objc_getAssociatedObject(self, &textViewProxyKey);
    if (!proxy) {
        proxy = [CLTextViewProxy new];
        proxy.delegate = self;
        objc_setAssociatedObject(self, &textViewProxyKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
}

- (void)placeholder_swizzling_layoutSubviews {
    [self placeholder_swizzling_layoutSubviews];
    if (objc_getAssociatedObject(self, &placeholderLabelKey)) {
        float left=kLeftX,top=kTopY,hegiht=self.bounds.size.height;
        CGFloat placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
        CGRect frame=self.placeholderLabel.frame;
        frame.origin.x=left;
        frame.origin.y=top;
        frame.size.height=hegiht;
        frame.size.width=placeholdeWidth;
        self.placeholderLabel.frame=frame;
        [self.placeholderLabel sizeToFit];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    objc_setAssociatedObject(self, &placeholderStringKey, placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setAttributePlaceholder:(NSAttributedString *)attributePlaceholder {
    self.placeholderLabel.attributedText = attributePlaceholder;
    objc_setAssociatedObject(self, &attplaceholderStringKey, attributePlaceholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSAttributedString *)attributePlaceholder {
    return objc_getAssociatedObject(self, &attplaceholderStringKey);
}


- (NSString *)placeholder {
    return objc_getAssociatedObject(self, &placeholderStringKey);
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    [self placeholderLabel].font = placeholderFont;
}

- (UIFont *)placeholderFont {
    return [self placeholderLabel].font;
}

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, &placeholderLabelKey);
    if (!label) {
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
        float left=kLeftX,top=kTopY,hegiht=30;
        CGFloat placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
        label.frame = CGRectMake(left, top , placeholdeWidth, hegiht);
        [self addSubview:label];
        objc_setAssociatedObject(self, &placeholderLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:[self textViewProxy]
                                                 selector:@selector(textViewDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [self addObserver:self forKeyPath:@"layer.borderWidth" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return label;
}

- (void)textViewDidChange {
    if (self.text && self.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewProxy:(CLTextViewProxy *)proxy textViewDidChange:(UITextView *)textView {
    if (textView == self) {
        [self textViewDidChange];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"layer.borderWidth"]||
        [keyPath isEqualToString:@"text"]) {
        [self textViewDidChange];
    }
}

@end

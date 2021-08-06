//
//  UILabel+CLAttributeTap.m
//  AttributeLabel
//
//  Created by fang liao on 2019/11/28.
//  Copyright © 2019 chao. All rights reserved.
//

#import "UILabel+CLAttributeTap.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import "MethodSwizzle.h"

NSAttributedStringKey const ISTapAttributeName = @"ISTapAttributeName";

@interface CLLabelAttributeItem : NSObject
@property (nonatomic, copy) NSString *str;
@property (nonatomic) NSRange range;
@end

@implementation CLLabelAttributeItem
@end

@implementation UILabel (CLAttributeTap)

#pragma mark - AssociatedObjects

+ (void)load {
    SwizzleMethod(self, @selector(setAttributedText:), @selector(swizze_setAttributedText:));
}

- (void)swizze_setAttributedText:(NSAttributedString *)attributedText {
    if (attributedText == nil) {
        [self swizze_setAttributedText:nil];
        return;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:attributedText.string];
    NSMutableArray *tmpArray = [NSMutableArray array];
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (range.length > 0) {
            NSMutableDictionary *dict = [attrs mutableCopy];
            [dict removeObjectForKey:ISTapAttributeName];
            [attr addAttributes:dict range:range];
            if (![dict objectForKey:NSFontAttributeName]) { // 没有设置字体
                [attr addAttribute:NSFontAttributeName value:self.font?:[UIFont systemFontOfSize:15] range:range];
            }
            id tapValue = [attrs objectForKey:ISTapAttributeName];
            if (tapValue) {
                [tmpArray addObject:NSStringFromRange(range)];
                NSAssert([tapValue isKindOfClass:[UIColor class]], @"值必须为颜色");
                [attr addAttribute:NSForegroundColorAttributeName value:tapValue range:range];
            }
        }
    }];
    [self swizze_setAttributedText:attr];
    if (tmpArray.count > 0) {
        [self addAttributeTapActionWithRanges:tmpArray];
    }
}

#pragma mark - AssociatedObjects

- (NSMutableArray *)attributeStrings {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings {
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEffectDic:(NSMutableDictionary *)effectDic {
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapAction {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapAction:(BOOL)isTapAction {
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (id<CLAttributeTapActionDelegate>)delegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDelegate:(id<CLAttributeTapActionDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enabledTapEffect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledTapEffect:(BOOL)enabledTapEffect {
    objc_setAssociatedObject(self, @selector(enabledTapEffect), @(enabledTapEffect), OBJC_ASSOCIATION_ASSIGN);
    self.isTapEffect = enabledTapEffect;
}
// 扩大点击区域
- (BOOL)enlargeTapArea {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = @(YES);
        objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_ASSIGN);
    }
    return [number boolValue];
}

- (void)setEnlargeTapArea:(BOOL)enlargeTapArea {
    objc_setAssociatedObject(self, @selector(enlargeTapArea), @(enlargeTapArea), OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)tapHighlightedColor {
    UIColor * color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setTapHighlightedColor:(UIColor *)tapHighlightedColor {
    objc_setAssociatedObject(self, @selector(tapHighlightedColor), tapHighlightedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapEffect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapEffect:(BOOL)isTapEffect {
    objc_setAssociatedObject(self, @selector(isTapEffect), @(isTapEffect), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction

- (void)addAttributeTapActionWithRanges:(NSArray<NSString *> *)ranges {
    [self removeAttributeTapActions];
    [self cl_getRangesWithRanges:ranges];
    self.userInteractionEnabled = YES;
}

- (void)removeAttributeTapActions {
    self.effectDic = nil;
    self.isTapAction = NO;
    self.attributeStrings = [NSMutableArray array];
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    if (objc_getAssociatedObject(self, @selector(enabledTapEffect))) {
        self.isTapEffect = self.enabledTapEffect;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    BOOL ret = [self cl_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.isTapEffect) {
            [weakSelf cl_saveEffectDicWithRange:range];
            [weakSelf cl_tapEffectWithStatus:YES];
        }
    }];
    if (!ret) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(cl_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    BOOL ret = [self cl_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(attributeTapActionInLabel:string:range:index:)]) {
            [weakSelf.delegate attributeTapActionInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(cl_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    BOOL ret = [self cl_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(attributeTapActionInLabel:string:range:index:)]) {
            [weakSelf.delegate attributeTapActionInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - getTapFrame
- (BOOL)cl_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 20));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    CGFloat total_height =  [self cl_textSizeWithAttributedString:self.attributedText width:self.bounds.size.width numberOfLines:0].height;
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = [self cl_transformForCoreText];
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self cl_getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        CGFloat lineOutSpace = (self.bounds.size.height - total_height) / 2;
        rect.origin.y = lineOutSpace + [self cl_getLineOrign:line];
        if (self.enlargeTapArea) {
            rect.origin.y -= 5;
            rect.size.height += 10;
        }
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));

            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            NSInteger link_count = self.attributeStrings.count;
            for (int j = 0; j < link_count; j++) {
                CLLabelAttributeItem *model = self.attributeStrings[j];
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (CGAffineTransform)cl_transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)cl_getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
        attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
    }
    height = [self cl_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)cl_getLineOrign:(CTLineRef)line {
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0.;
    }else {
        NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
        }
        return [self cl_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    }
}

- (CGSize)cl_textSizeWithAttributedString:(NSAttributedString *)attributedString width:(float)width numberOfLines:(NSInteger)numberOfLines {
    @autoreleasepool {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLabel.numberOfLines = numberOfLines;
        sizeLabel.attributedText = attributedString;
        CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        return fitSize;
    }
}

#pragma mark - tapEffect
- (void)cl_tapEffectWithStatus:(BOOL)status {
    if (self.isTapEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.tapHighlightedColor range:NSMakeRange(0, subAtt.string.length)];
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)cl_saveEffectDicWithRange:(NSRange)range {
    self.effectDic = [NSMutableDictionary dictionary];
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)cl_getRangesWithStrings:(NSArray <NSString *>  *)strings {
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [totalStr rangeOfString:obj];
        if (range.length != 0) {
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf cl_getStringWithRange:range]];
            CLLabelAttributeItem *model = [CLLabelAttributeItem new];
            model.range = range;
            model.str = obj;
            [weakSelf.attributeStrings addObject:model];
        }
    }];
}

- (void)cl_getRangesWithRanges:(NSArray <NSString *>  *)ranges {
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [ranges enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(obj);
        NSAssert(totalStr.length >= range.location + range.length, @"NSRange(%ld,%ld) is out of bounds",range.location,range.length);
        NSString * string = [totalStr substringWithRange:range];
        CLLabelAttributeItem *model = [CLLabelAttributeItem new];
        model.range = range;
        model.str = string;
        [weakSelf.attributeStrings addObject:model];
    }];
}

- (NSString *)cl_getStringWithRange:(NSRange)range {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end

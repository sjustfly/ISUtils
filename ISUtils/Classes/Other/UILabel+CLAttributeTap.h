//
//  UILabel+CLAttributeTap.h
//  AttributeLabel
//
//  Created by fang liao on 2019/11/28.
//  Copyright © 2019 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSAttributedStringKey const ISTapAttributeName;

@protocol CLAttributeTapActionDelegate <NSObject>
@optional
/**
 *  CLAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)attributeTapActionInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index;
@end

@interface UILabel (CLAttributeTap)

@property (nonatomic, weak) id<CLAttributeTapActionDelegate> delegate;

// 扩大点击区域 default YES
@property(nonatomic) BOOL enlargeTapArea;
// 点击效果 default YES
@property(nonatomic) BOOL enabledTapEffect;
// 点击高亮色 默认是[UIColor lightGrayColor] 
@property (nonatomic, strong) UIColor * tapHighlightedColor;

//  根据range给文本添加点击事件delegate回调
//  @param ranges  需要添加的Range字符串数组
- (void)addAttributeTapActionWithRanges:(NSArray <NSString *> *)ranges;

//   删除label上的点击事件
- (void)removeAttributeTapActions;

@end

NS_ASSUME_NONNULL_END

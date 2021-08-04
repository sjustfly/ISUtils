//
//  UIButton+CLCommonHandle.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/13.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLImagePosition) {
    CLImagePositionLeft = 0,              //图片在左，文字在右，默认
    CLImagePositionRight = 1,             //图片在右，文字在左
    CLImagePositionTop = 2,               //图片在上，文字在下
    CLImagePositionBottom = 3,            //图片在下，文字在上
};

typedef void(^BlockHandle) (void);

@interface UIButton (CLCommonHandle)

- (void)handle:(BlockHandle)block;

- (void)setImagePosition:(CLImagePosition)postion;
/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 *  
 */
- (void)setImagePosition:(CLImagePosition)postion spacing:(CGFloat)spacing;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)hideIndicator;

@end

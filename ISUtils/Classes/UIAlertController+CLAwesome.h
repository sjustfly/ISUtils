//
//  UIAlertController+CLAwesome.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^actionHandler)(UIAlertController *alert, UIAlertAction *action, NSUInteger index);
typedef void(^textFieldHandler)(UITextField *textField, NSUInteger index);

@interface UIAlertController (CLAwesome)

// 调用show, 会通过队列的形式展示，一个消失以后再展示另一个
- (void)show;

// 所有文本的对齐方式
- (void)setTextAlignment:(NSTextAlignment)textAlignment;

+ (UIAlertController *)alertWithMessage:(NSString *)message
                            cancelTitle:(NSString *)cancelTitle
                          actionHandler:(actionHandler)actionBlock;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                        actionHandler:(actionHandler)actionBlock;

+ (UIAlertController *)alertWithTitle1:(NSString *)title
                               message:(NSString *)message
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                         actionHandler:(actionHandler)actionBlock;

+ (UIAlertController *)alertWithTitle2:(NSString *)title
                               message:(NSString *)message
                     destructiveTitles:(NSArray *)destructiveTitle
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                         actionHandler:(actionHandler)actionBlock;

/**
 *  按钮--中间
 *
 *  @param title            提示标题
 *  @param message          提示信息
 *  @param textFieldNumber  输入框个数
 *  @param actionTitle      按钮标题，数组
 *  @param textFieldBlock   输入框响应事件
 *  @param actionBlock      按钮响应事件
 */
+ (UIAlertController *)alertWithTitle3:(NSString *)title
                               message:(NSString *)message
                       textFieldNumber:(NSUInteger)textFieldNumber
                     destructiveTitles:(NSArray *)destructiveTitle
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                      textFieldHandler:(textFieldHandler)textFieldBlock
                         actionHandler:(actionHandler)actionBlock;


/**
 *  按钮--底部
 *
 *  @param title            提示标题
 *  @param message          提示信息
 *  @param actionTitle      按钮标题，数组
 *  @param actionBlock      按钮响应事件
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title
                                     message:(NSString *)message
                           destructiveTitles:(NSArray *)destructiveTitle
                                actionTitles:(NSArray *)actionTitle
                                 cancelTitle:(NSString *)cancelTitle
                               actionHandler:(actionHandler)actionBlock;

@end

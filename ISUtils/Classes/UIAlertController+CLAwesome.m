//
//  UIAlertController+CLAwesome.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIAlertController+CLAwesome.h"
#import "MethodSwizzle.h"

static UIWindow *s_alertWindow;

@interface UIAlertController (Private)

+ (void)setAlertWindow:(UIWindow *)alertWindow;
+ (UIWindow *)alertWindow;

@end

@implementation UIAlertController (Private)

+ (void)setAlertWindow:(UIWindow *)alertWindow {
    s_alertWindow = alertWindow;
}

+ (UIWindow *)alertWindow {
    return s_alertWindow;
}

@end

static char *tagKey = "tagKey";
static char *kFindFirstLabel = "kFindFirstLabel";

@implementation UIAlertController (CLAwesome)

+ (void)load {
    SwizzleMethod(self, @selector(viewDidDisappear:), @selector(swizzle_viewDidDisappear:));
}

#pragma mark - property

- (void)setTag:(NSInteger)tag {
    objc_setAssociatedObject(self, tagKey, @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tag {
    return [objc_getAssociatedObject(self, tagKey) integerValue];
}

#pragma mark - private method

- (void)swizzle_viewDidDisappear:(BOOL)animated {
    [self swizzle_viewDidDisappear:animated];
    // precaution to insure window gets destroyed
    self.class.alertWindow.hidden = YES;
    self.class.alertWindow = nil;
}

#pragma mark - public method

- (void)show {
    if (!self.class.alertWindow) {
        self.class.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.class.alertWindow.rootViewController = [[UIViewController alloc] init];
        self.class.alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [self.class.alertWindow makeKeyAndVisible];
    }
    if (!self.class.alertWindow.rootViewController.presentedViewController) {
        [self.class.alertWindow.rootViewController presentViewController:self animated:YES completion:nil];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [self setTextAlignment:textAlignment view:self.view];
}

// 找到的第一个label为titleLabel NSTextAlignmentCenter
- (void)setTextAlignment:(NSTextAlignment)textAlignment view:(UIView *)view {
    __weak typeof(self) weakSelf = self;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([obj isKindOfClass:[UILabel class]]) {
            if([objc_getAssociatedObject(self, kFindFirstLabel) boolValue]) {
                ((UILabel *)obj).textAlignment = textAlignment;
            };
            objc_setAssociatedObject(self, kFindFirstLabel, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [strongSelf setTextAlignment:textAlignment view:obj];
    }];
}

+ (UIAlertController *)alertWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle actionHandler:(actionHandler)actionBlock {
    return [UIAlertController alertWithTitle3:nil message:message textFieldNumber:0  destructiveTitles:nil actionTitles:nil cancelTitle:cancelTitle textFieldHandler:nil actionHandler:actionBlock];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                        actionHandler:(actionHandler)actionBlock {
    return [UIAlertController alertWithTitle3:title message:message textFieldNumber:0  destructiveTitles:nil actionTitles:nil cancelTitle:cancelTitle textFieldHandler:nil actionHandler:actionBlock];
}

+ (UIAlertController *)alertWithTitle1:(NSString *)title
                               message:(NSString *)message
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                         actionHandler:(actionHandler)actionBlock {
    return [UIAlertController alertWithTitle3:title message:message textFieldNumber:0  destructiveTitles:nil actionTitles:actionTitle cancelTitle:cancelTitle textFieldHandler:nil actionHandler:actionBlock];
}

+ (UIAlertController *)alertWithTitle2:(NSString *)title
                               message:(NSString *)message
                     destructiveTitles:(NSArray *)destructiveTitle
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                         actionHandler:(actionHandler)actionBlock {
    return [UIAlertController alertWithTitle3:title message:message textFieldNumber:0 destructiveTitles:destructiveTitle actionTitles:actionTitle cancelTitle:cancelTitle textFieldHandler:nil actionHandler:actionBlock];
}

+ (UIAlertController *)alertWithTitle3:(NSString *)title
                               message:(NSString *)message
                       textFieldNumber:(NSUInteger)textFieldNumber
                     destructiveTitles:(NSArray *)destructiveTitle
                          actionTitles:(NSArray *)actionTitle
                           cancelTitle:(NSString *)cancelTitle
                      textFieldHandler:(textFieldHandler)textFieldBlock
                         actionHandler:(actionHandler)actionBlock {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                if(textFieldBlock) textFieldBlock(textField, i);
            }];
        }
    }
    NSInteger index = 0;
    if (cancelTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
            if(actionBlock) actionBlock(alertC, action,  index);
        }];
        [alertC addAction:action];
        index++;
    }
    if (destructiveTitle.count > 0) {
        for (NSString *str in destructiveTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)  {
                if(actionBlock) actionBlock(alertC, action, index);
            }];
            index++;
            [alertC addAction:action];
        }
    }
    if (actionTitle.count > 0) {
        for (NSString *str in actionTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                if(actionBlock) actionBlock(alertC, action, index);
            }];
            index++;
            [alertC addAction:action];
        }
    }
    return alertC;
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title
                                     message:(NSString *)message
                           destructiveTitles:(NSArray *)destructiveTitle
                                actionTitles:(NSArray *)actionTitle
                                 cancelTitle:(NSString *)cancelTitle
                               actionHandler:(actionHandler)actionBlock {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger index = 0;
    if (cancelTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
            if(actionBlock) actionBlock(alertC, action,  index);
        }];
        [alertC addAction:action];
    }
    index = destructiveTitle.count+actionTitle.count;
    if (actionTitle.count > 0) {
        for (NSString *str in [actionTitle.reverseObjectEnumerator allObjects]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                if(actionBlock) actionBlock(alertC, action, index);
            }];
            index--;
            [alertC addAction:action];
        }
    }
    if (destructiveTitle.count > 0) {
        for (NSString *str in [destructiveTitle.reverseObjectEnumerator allObjects]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)  {
                if(actionBlock) actionBlock(alertC, action, index);
            }];
            index--;
            [alertC addAction:action];
        }
    }
    return alertC;
}

@end

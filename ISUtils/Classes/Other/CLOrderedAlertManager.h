//
//  CLOrderedAlertManager.h
//  MobileGjp
//
//  Created by fang liao on 2020/4/17.
//  Copyright © 2020 Way. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CLAlertPriority) {
    ISAlertPriorityLow = 100,
    ISAlertPriorityDefault = 1000,
    ISAlertPriorityHigh = 10000,
    ISAlertPriorityRequired = 100000
};

@interface UIViewController (CLAlertPriority)

@property (nonatomic, assign) NSInteger errorTag;

@end

// 该类主要是或者自己继承的UIViewController多次弹窗的管理问题(alert弹窗，不行)
// 由于使用的是presentViewController, 但是一个controller一般只能弹出一个，弹出多个的时候就需要队列管理
@interface CLOrderedAlertManager : NSObject

/*这里特别注意，present是哪个vc，dismiss也必须用该vc,不能self.navigationContoller present 然后self dismiss, present和dismiss对象不一样会导致意想不到的错误*/
// priority为ISAlertPriorityDefault
+ (void)present:(UIViewController *)viewController;
+ (void)present:(UIViewController *)viewController priority:(CLAlertPriority)priority;
// 移除队列里的controller
+ (BOOL)containController:(UIViewController *)viewController;
+ (void)removeControllerInQuene:(UIViewController *)viewController;
// 展示下一个
+ (void)presentNextIfNeeded;
// 包含某类
+ (BOOL)containControllerClass:(Class)aClass;
+ (BOOL)containTag:(NSInteger)tag;
+ (void)clean;
+ (void)cleanCache;

@end

NS_ASSUME_NONNULL_END

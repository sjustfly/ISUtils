//
//  CLOrderedAlertManager.m
//  MobileGjp
//
//  Created by fang liao on 2020/4/17.
//  Copyright © 2020 Way. All rights reserved.
//

#import "CLOrderedAlertManager.h"
#import "MethodSwizzle.h"

#define alertWeakSelf typeof(self) __weak weakself = self
#define alertStrongSelf typeof(self) __strong self = weakself;

typedef void(^UIViewControllerDismissBlock)(UIViewController *vc);

@interface UIViewController (CLAlertPriority)
// alert 优先级，数值越大，优先展示
@property(nonatomic, assign) CLAlertPriority alertPriority;
@property(nonatomic, copy) UIViewControllerDismissBlock controllerDismissBlock;

@end

@implementation UIViewController (CLAlertPriority)

+ (void)load {
    SwizzleMethod(self, @selector(dismissViewControllerAnimated:completion:), @selector(alertSwizzle_dismissViewControllerAnimated:completion:));
}

// UIAlertController 也是调用改方法处理
- (void)alertSwizzle_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    alertWeakSelf;
    [self alertSwizzle_dismissViewControllerAnimated:flag completion:^{
        alertStrongSelf;
        UIViewController *vc = self;
        // 避免present的nav,但是dismiss的是self
        while (!vc.controllerDismissBlock && vc.parentViewController) {
            vc = vc.parentViewController;
        }
        if (vc.controllerDismissBlock) {
            vc.controllerDismissBlock(vc);
        }
        if (completion) { completion(); }
    }];
}

- (void)setAlertPriority:(CLAlertPriority)alertPriority {
    objc_setAssociatedObject(self, @selector(alertPriority), @(alertPriority), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLAlertPriority)alertPriority {
    return [objc_getAssociatedObject(self, @selector(alertPriority)) integerValue];
}

- (void)setControllerDismissBlock:(UIViewControllerDismissBlock)controllerDismissBlock {
    objc_setAssociatedObject(self, @selector(controllerDismissBlock), [controllerDismissBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewControllerDismissBlock)controllerDismissBlock {
    return objc_getAssociatedObject(self, @selector(controllerDismissBlock));
}

- (void)setErrorTag:(NSInteger)errorTag {
    objc_setAssociatedObject(self, @selector(errorTag), @(errorTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)errorTag {
    return [objc_getAssociatedObject(self, @selector(errorTag)) integerValue];
}

@end

@interface CLOrderedAlertManager ()
// 弹窗队列
@property(nonatomic) NSMutableArray <UIViewController *>*alertQuene;
// 有的暂时被移除了，但是后面还要加进去
@property(nonatomic) NSMutableArray <UIViewController *>*removedCache;

@property(nonatomic) UIViewController *presentingViewController;

@end

@implementation CLOrderedAlertManager

- (NSMutableArray *)alertQuene {
    if (!_alertQuene) {
        _alertQuene = [NSMutableArray array];
    }
    return _alertQuene;
}

- (NSMutableArray *)removedCache {
    if (!_removedCache) {
        _removedCache = [NSMutableArray array];
    }
    return _removedCache;
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CLOrderedAlertManager *s_manager;
    dispatch_once(&onceToken, ^{
        s_manager = [CLOrderedAlertManager new];
    });
    return s_manager;
}

+ (void)present:(UIViewController *)viewController {
    [self present:viewController priority:ISAlertPriorityDefault];
}

+ (void)removeControllerInQuene:(UIViewController *)viewController {
    [[self manager] removeControllerInQuene:viewController];
}

+ (void)present:(UIViewController *)viewController priority:(CLAlertPriority)priority {
    [[self manager] present:viewController priority:priority];
}

+ (void)presentNextIfNeeded {
    [[self manager] presentNextIfNeeded];
}

+ (BOOL)containControllerClass:(Class)aClass {
    return [[self manager] containControllerClass:aClass];
}

+ (BOOL)containTag:(NSInteger)tag {
    return [[self manager] containTag:tag];
}

+ (BOOL)containController:(UIViewController *)viewController {
    return [[self manager] containController:viewController];
}

- (BOOL)containController:(UIViewController *)viewController {
    return [self.alertQuene containsObject:viewController];;
}

- (BOOL)containTag:(NSInteger)tag {
    BOOL flag = NO;
    for (UIViewController *vc in self.alertQuene) {
        if (vc.errorTag == tag) {
            flag = YES;
            break;
        }
    }
    return flag;
}

+ (void)clean {
    [[self manager] clean];
}

+ (void)cleanCache {
    [[self manager] cleanCache];
}

- (void)clean {
    [[self alertQuene] removeAllObjects];
}

- (void)cleanCache {
    [[self removedCache] removeAllObjects];
}

- (BOOL)containControllerClass:(Class)aClass {
    for (UIViewController *vc in self.alertQuene) {
        if ([vc isKindOfClass:aClass]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeControllerInQuene:(UIViewController *)viewController {
    [self.alertQuene removeObject:viewController];
}

- (void)present:(UIViewController *)viewController priority:(CLAlertPriority)priority {
    NSAssert(![viewController isMemberOfClass:UIAlertController.class], @"由于UIAlertController点击按钮后dismiss不好监听，因此不支持该类及其派生类。");
    [viewController setControllerDismissBlock:^(UIViewController *vc) {
        self.presentingViewController = nil;
        [self.alertQuene removeObject:vc];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(presentNextIfNeeded) object:nil];
        [self performSelector:@selector(presentNextIfNeeded) withObject:nil afterDelay:0.05];
    }];
    viewController.alertPriority = priority;
    [self.alertQuene insertObject:viewController atIndex:0];
    [self.alertQuene sortUsingComparator:^NSComparisonResult(UIViewController * _Nonnull obj1, UIViewController * _Nonnull obj2) {
        return obj1.alertPriority > obj2.alertPriority ? NSOrderedDescending : NSOrderedAscending;
    }];
    UIViewController *presented = self.presentingViewController;
    if (presented && self.alertQuene.lastObject != presented) {
        [self.removedCache addObject:presented];
        [presented dismissViewControllerAnimated:NO completion:^{}];
    } else {
        if ([self topPresentedViewController].presentedViewController) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(presentNextIfNeeded) object:nil];
            [self performSelector:@selector(presentNextIfNeeded) withObject:nil afterDelay:0.1];
        } else {
            self.presentingViewController = viewController;
            [[self topPresentedViewController] presentViewController:viewController animated:YES completion:nil];
        }
    }
}

#pragma mark - helper method

- (void)presentNextIfNeeded {
    if (self.removedCache.count) {
        NSMutableArray *tmp = [NSMutableArray array];
        [tmp addObjectsFromArray:self.removedCache];
        [self.removedCache removeAllObjects];
        
        [tmp addObjectsFromArray:self.alertQuene];
        [self.alertQuene removeAllObjects];
        [self.alertQuene addObjectsFromArray:tmp];
        [self.alertQuene sortUsingComparator:^NSComparisonResult(UIViewController * _Nonnull obj1, UIViewController * _Nonnull obj2) {
            return obj1.alertPriority > obj2.alertPriority ? NSOrderedDescending : NSOrderedAscending;
        }];
    }
    if (self.alertQuene.count) {
        UIViewController *vc = [self.alertQuene lastObject];
        if ([self topPresentedViewController].presentedViewController) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(presentNextIfNeeded) object:nil];
            [self performSelector:@selector(presentNextIfNeeded) withObject:nil afterDelay:0.1];
        } else {
            self.presentingViewController = vc;
            [[self topPresentedViewController] presentViewController:vc animated:YES completion:nil];
        }
    } else { // 没有弹窗了
        self.presentingViewController = nil;
    }
}

- (UIViewController *)topPresentedViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end

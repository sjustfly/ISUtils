//
//  UIApplication+Edge.h
//  MobileGjp
//
//  Created by chao luo on 5/23/19.
//  Copyright © 2019 Way. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSafeAreaTop [[UIApplication sharedApplication] windowSafeTop]
#define kSafeAreaBottom [[UIApplication sharedApplication] windowSafeBottom]
#define kSafeAreaWidth [[UIApplication sharedApplication] windowSafeWith]
#define kSafeAreaHeight [[UIApplication sharedApplication] windowSafeHeight]

@interface UIApplication (Edge)

// safe area 如果是<iOS11 则为window去掉statusBar，如果>=iOS11 则为safeArea
- (UIEdgeInsets)windowSafeArea;
- (CGFloat)windowSafeTop;
- (CGFloat)windowSafeBottom;
- (CGFloat)windowSafeHeight;
- (CGFloat)windowSafeWith;

@end

NS_ASSUME_NONNULL_END

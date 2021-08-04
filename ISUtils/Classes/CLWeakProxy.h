//
//  CLWeakProxy.h
//  iOSFrameworkSample
//
//  Created by 普拉斯 on 2018/3/7.
//  Copyright © 2018年 sjustfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLWeakProxy : NSProxy

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end

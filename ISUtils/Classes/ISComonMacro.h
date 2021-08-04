//
//  ISComonMacro.h
//  Pods
//
//  Created by chao luo on 5/3/19.
//

#ifndef ISComonMacro_h
#define ISComonMacro_h

#import "UIImage+AssociatedBundle.h"

#define URL(url) [NSURL URLWithString:url]

#define IMAGE_BUNDLE_NAMED(imgName) [UIImage imageFromBundleNamed:imgName]

// 当前版本
#define SystemVersion          ([[UIDevice currentDevice] systemVersion])

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#endif /* ISComonMacro_h */

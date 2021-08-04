//
//  UIImage+AssociatedBundle.h
//  printing
//
//  Created by fang liao on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AssociatedBundle)

+ (UIImage *)imageFromBundleNamed:(NSString *)named;

@end

NS_ASSUME_NONNULL_END

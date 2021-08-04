//
//  UIImage+AssociatedBundle.m
//  printing
//
//  Created by fang liao on 2020/11/19.
//

#import "UIImage+AssociatedBundle.h"
#import "NSBundle+AssociatedBundle.h"

@implementation UIImage (AssociatedBundle)

+ (UIImage *)imageFromBundleNamed:(NSString *)named {
    NSBundle *bundle = [NSBundle bundleWithBundleName:@"printing" podName:@"printing"];
    return [UIImage imageNamed:named inBundle:bundle compatibleWithTraitCollection:nil];
}

@end

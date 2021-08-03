//
//  UINavigationItem+CLLoading.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/20.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UINavigationItem+CLLoading.h"

#import <objc/runtime.h>

static void *JKLoaderPositionAssociationKey = &JKLoaderPositionAssociationKey;
static void *JKSubstitutedViewAssociationKey = &JKSubstitutedViewAssociationKey;

@implementation UINavigationItem (CLLoading)

- (void)startAnimatingAt:(NavBarLoaderPosition)position {
    // stop previous if animated
    [self stopAnimating];
    
    // hold reference for position to stop at the right place
    objc_setAssociatedObject(self, JKLoaderPositionAssociationKey, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // substitute bar views to loader and hold reference to them for restoration
    switch (position) {
        case NavBarLoaderPositionLeft:
            objc_setAssociatedObject(self, JKSubstitutedViewAssociationKey, self.leftBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.leftBarButtonItem.customView = loader;
            break;
            
        case NavBarLoaderPositionCenter:
            objc_setAssociatedObject(self, JKSubstitutedViewAssociationKey, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.titleView = loader;
            break;
            
        case NavBarLoaderPositionRight:
            objc_setAssociatedObject(self, JKSubstitutedViewAssociationKey, self.rightBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.rightBarButtonItem.customView = loader;
            break;
    }
    
    [loader startAnimating];
}

- (void)stopAnimating {
    NSNumber* positionToRestore = objc_getAssociatedObject(self, JKLoaderPositionAssociationKey);
    id componentToRestore = objc_getAssociatedObject(self, JKSubstitutedViewAssociationKey);
    
    // restore UI if animation was in a progress
    if (positionToRestore) {
        switch (positionToRestore.intValue) {
            case NavBarLoaderPositionLeft:
                self.leftBarButtonItem.customView = componentToRestore;
                break;
                
            case NavBarLoaderPositionCenter:
                self.titleView = componentToRestore;
                break;
                
            case NavBarLoaderPositionRight:
                self.rightBarButtonItem.customView = componentToRestore;
                break;
        }
    }
    
    objc_setAssociatedObject(self, JKLoaderPositionAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, JKSubstitutedViewAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

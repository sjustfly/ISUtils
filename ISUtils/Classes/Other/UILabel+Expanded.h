//
//  UILabel+Expanded.h
//  SAX_iOS
//
//  Created by 普拉斯 on 16/10/18.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Expanded)

+ (UILabel *)labelWithFontSize:(CGFloat)size color:(uint32_t)hex;

//  在原有fontSzie 和 frame 不变的基础上，增加一个
@property(nonatomic, assign) UIEdgeInsets edgeInsets;

@end

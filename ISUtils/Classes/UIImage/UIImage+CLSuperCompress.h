//
//  UIImage+CLSuperCompress.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/20.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLSuperCompress)

- (NSData *)compressImageToMaxFileSize:(NSInteger)maxFileSize;

/**
 *  压缩上传图片到指定字节
 *
 *  @param image     压缩的图片
 *  @param maxLength 压缩后最大字节大小
 *
 *  @return 压缩后图片的二进制
 */
+ (NSData *)compressImage:(UIImage *)image toMaxLength:(NSInteger)maxLength maxWidth:(NSInteger)maxWidth;

/**
 *  获得指定size的图片
 *
 *  @param image   原始图片
 *  @param newSize 指定的size
 *
 *  @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *) image withNewSize:(CGSize) newSize;

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
+ (CGSize)scaleImage:(UIImage *) image withLength:(CGFloat) imageLength;

/**
 *  将图片转换为黑白图片
 *
 *  @return 黑白图片
 */
- (UIImage *)blackAndWhiteImage;

@end

//
//  UIImage+CLSuperCompress.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/20.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UIImage+CLSuperCompress.h"

@implementation UIImage (CLSuperCompress)

- (NSData *)compressImageToMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat minCompression = 0.1f;
    UIImage *image = self;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > minCompression) {
        compression -= 0.2;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}


+ (NSData *)compressImage:(UIImage *)image toMaxLength:(NSInteger)maxLength maxWidth:(NSInteger)maxWidth{
    NSAssert(maxLength > 0, @"图片的大小必须大于 0");
    NSAssert(maxWidth > 0, @"图片的最大边长必须大于 0");
    
    CGSize newSize = [self scaleImage:image withLength:maxWidth];
    UIImage *newImage = [self resizeImage:image withNewSize:newSize];
    
    CGFloat compress = 0.9f;
    NSData *data = UIImageJPEGRepresentation(newImage, compress);
    
    while (data.length > maxLength && compress > 0.01) {
        compress -= 0.02f;
        
        data = UIImageJPEGRepresentation(newImage, compress);
    }
    return data;
}

+ (UIImage *)resizeImage:(UIImage *)image withNewSize:(CGSize)newSize {
    if (!image) { return nil; }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGSize)scaleImage:(UIImage *)image withLength:(CGFloat)imageLength {
    if (!image) { return CGSizeZero; }
    CGFloat newWidth = 0.0f;
    CGFloat newHeight = 0.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if (width > imageLength || height > imageLength) {
        if (width > height) {
            newWidth = imageLength;
            newHeight = newWidth * height / width;
            
        }else if(height > width){
            newHeight = imageLength;
            newWidth = newHeight * width / height;
            
        }else{
            
            newWidth = imageLength;
            newHeight = imageLength;
        }
        
    } else {
        return CGSizeMake(width, height);
    }
    return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)blackAndWhiteImage {
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"
                                  keysAndValues:kCIInputImageKey,beginImage,kCIInputColorKey,[CIColor colorWithCGColor:[UIColor blackColor].CGColor],nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    return newImage;
}
@end

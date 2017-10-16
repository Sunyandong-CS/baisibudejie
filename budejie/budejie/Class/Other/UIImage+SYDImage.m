//
//  UIImage+SYDImage.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "UIImage+SYDImage.h"

@implementation UIImage (SYDImage)

+ (UIImage *)imageOriginalWithName:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)syd_circleImage {
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)syd_circleImage:(UIImage *)image {
    return [image syd_circleImage];
}

@end


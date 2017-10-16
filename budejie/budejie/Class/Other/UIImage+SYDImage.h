//
//  UIImage+SYDImage.h
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SYDImage)
+ (UIImage *)imageOriginalWithName:(NSString *)imageName;


- (instancetype)syd_circleImage;
+ (instancetype)syd_circleImage:(UIImage *)image;

@end

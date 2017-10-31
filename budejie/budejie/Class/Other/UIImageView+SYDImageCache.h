//
//  UIImageView+SYDImageCache.h
//  budejie
//
//  Created by 孙艳东 on 2017/10/19.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (SYDImageCache)

/**
 在不同网络状况下下载图片，处理切换网络后大小图下载以及缓存重用问题

 @param originImage 原始图像（较大）
 @param thumbbailImage 缩略图像
 @param placeholderImage 占位图片
 */
- (void)SYD_downLoadOriginImage:(NSString *)originImage
                 thumbbailImage:(NSString *)thumbbailImage
               placeholderImage:(UIImage *)placeholderImage
                      completed:(SDExternalCompletionBlock)completedBlock;

- (void)serHeader:(UIImage *)headerImage placeholder:(UIImage *)placeholder;

@end

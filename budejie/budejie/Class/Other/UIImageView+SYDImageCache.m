//
//  UIImageView+SYDImageCache.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/19.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "UIImageView+SYDImageCache.h"
#import <UIImageView+WebCache.h>
#import <AFNetworkReachabilityManager.h>
#import "UIImage+SYDImage.h"

@implementation UIImageView (SYDImageCache)

- (void)SYD_downLoadOriginImage:(NSString *)originImage
                 thumbbailImage:(NSString *)thumbbailImage
               placeholderImage:(UIImage *)placeholderImage
              completed:(SDWebImageDownloaderCompletedBlock)completedBlock{
    
    // 创建检测网络状况管理对象
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // SDWebImage使用图片url作为key缓存
    UIImage *oriImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:originImage];
    if (oriImage) { // 如果原图已经被下载过，直接使用原图
        self.image = oriImage;
        completedBlock(oriImage, nil, 0, [NSURL URLWithString:originImage]);
    }else {
        if (mgr.isReachableViaWiFi) {// wifi状况下下载大图
            [self sd_setImageWithURL:[NSURL URLWithString:originImage] placeholderImage:placeholderImage];
        }else if (mgr.isReachableViaWWAN) { // 3/4G网络状况下下载小图
            [self sd_setImageWithURL:[NSURL URLWithString:thumbbailImage] placeholderImage:placeholderImage];
        }else { // 断网状况下先看有没有下载缩略图。
            UIImage *thumbImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:thumbbailImage];
            if (thumbImage) { // 如果有缩略图，则设置图片为缩略图
                self.image = thumbImage;
                completedBlock(thumbImage, nil, 0, [NSURL URLWithString:thumbbailImage]);
            } else { // 由于cell重用机制，后面的cell可能会用到前面的，而又不能下载新的图片,所以需要设置Placeholder
                
                self.image = placeholderImage;
            }
        }
    }
}

- (void)serHeader:(NSString *)headerImage placeholhder:(UIImage *)placeholder{
    // 下载并设置圆形头像
    UIImage *placeholderImage = [UIImage syd_circleImage:placeholder];
    
    [self sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return ;
        }
        self.image = [image syd_circleImage];
    }];
}
@end

//
//  SYDTopicVideoView.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicVideoView.h"
#import "SYDTopicModel.h"
#import <UIImageView+WebCache.h>
#import <AFNetworkReachabilityManager.h>

@interface SYDTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *videoTime;

@end
@implementation SYDTopicVideoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(SYDTopicModel *)topic {
    _topic = topic;
    // 设置View属性
    self.playCount.text = [NSString stringWithFormat:@"%li次播放",(long)topic.playcount];
    
    self.videoTime.text = [NSString stringWithFormat:@"%02li : %02li",(long)topic.videotime / 60,(long)topic.videotime % 60];
    
    // 下载图片
    [self downLoadImageWithInternetStatus:topic];
}

- (void)downLoadImageWithInternetStatus:(SYDTopicModel *)topic {
    // 创建检测网络状况管理对象
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // SDWebImage使用图片url作为key缓存
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:topic.image1];
    UIImage *placeHolderImage = [UIImage imageNamed:@"mainCellBackground.png"];
    if (originImage) { // 如果原图已经被下载过，直接使用原图
        self.videoImage.image = originImage;
    }else {
        if (mgr.isReachableViaWiFi) {// wifi状况下下载大图
            [self.videoImage sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:placeHolderImage];
        }else if (mgr.isReachableViaWWAN) { // 3/4G网络状况下下载小图
            [self.videoImage sd_setImageWithURL:[NSURL URLWithString:topic.image0] placeholderImage:placeHolderImage];
        }else { // 断网状况下先看有没有下载缩略图。
            UIImage *thumbbailImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:topic.image0];
            if (thumbbailImage) { // 如果有缩略图，则设置图片为缩略图
                
                self.videoImage.image = placeHolderImage;
            } else { // 由于cell重用机制，后面的cell可能会用到前面的，而又不能下载新的图片,所以需要设置Placeholder
                
                self.videoImage.image = placeHolderImage;
            }
            
            self.videoImage.image = placeHolderImage;
        }
    }
}


@end

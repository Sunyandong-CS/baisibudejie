//
//  SYDTopicVoiceView.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicVoiceView.h"
#import "SYDTopicModel.h"
#import "UIImageView+SYDImageCache.h"

@interface SYDTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UILabel *voicePlayCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voicePlayButton;
@property (weak, nonatomic) IBOutlet UILabel *voiceTime;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;

@end
@implementation SYDTopicVoiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(SYDTopicModel *)topic {
    _topic = topic;
    // 设置View属性
    self.voicePlayCountLabel.text = [NSString stringWithFormat:@"%li次播放",(long)topic.playcount];
    
    self.voiceTime.text = [NSString stringWithFormat:@"%02li : %02li",(long)topic.videotime / 60,(long)topic.voicetime % 60];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"mainCellBackground.png"];
    // 下载图片
    [self.voiceImage SYD_downLoadOriginImage:topic.image1 thumbbailImage:topic.image0 placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return ;
        }
    }];
}

@end

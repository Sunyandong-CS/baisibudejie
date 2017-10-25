//
//  SYDTopicCell.m
//  budejie
//
//  Created by mymac on 2017/10/11.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicCell.h"
#import "SYDTopicModel.h"
#import "UIView+frame.h"
#import "UIImage+SYDImage.h"
#import <UIImageView+WebCache.h>
#import "SYDTopicVideoView.h"
#import "SYDTopicVoiceView.h"
#import "SYDTopicPictureView.h"

@interface SYDTopicCell ()
// 控件命名--> 功能加控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (weak, nonatomic) IBOutlet UIView *commentView;
/* 记录cell中间部分的View，防止重复加载 */
@property (nonatomic, strong) SYDTopicVoiceView *voiceView;
@property (nonatomic, strong) SYDTopicVideoView *videoView;
@property (nonatomic, strong) SYDTopicPictureView *pictureView;

@end

@implementation SYDTopicCell

#pragma mark -------
#pragma mark 懒加载cell的中间部分的View
- (SYDTopicVoiceView *)voiceView {
    if (_voiceView == nil) {
        _voiceView = [SYDTopicVoiceView viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}

- (SYDTopicVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [SYDTopicVideoView viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}
- (SYDTopicPictureView *)pictureView {
    if (_pictureView == nil) {
        _pictureView = [SYDTopicPictureView viewFromXib];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}




- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(SYDTopicModel *)topic {
    _topic = topic;
    // 设置头部和底部内容数据
    
    // 下载并设置圆形头像
    UIImage *placeholderImage = [UIImage syd_circleImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return ;
        }
        self.profileImageView.image = [image syd_circleImage];
    }];
    
    //    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image]];
    self.nameLabel.text = topic.name;
    self.passTimeLabel.text = topic.passtime;
    self.textContentLabel.text = topic.text;
    
    // 设置声音视频等内容
    if(topic.type == SYDTopicTypeVideo) {
        // 添加中部视频控件，并设置内容和frame
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        self.videoView.topic = topic;
        self.videoView.frame = self.topic.middleFrame;
        
    }else if(topic.type == SYDTopicTypePicture) {
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = self.topic.middleFrame;

    }else if (topic.type == SYDTopicTypeVoice) {
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        self.voiceView.topic = topic; 
        self.voiceView.frame = self.topic.middleFrame;

        
    }else if (topic.type == SYDTopicTypeJoke) {
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    //设置最热评论部分内容
    if (topic.top_cmt.count > 0) {// 最热评论部分有内容
        self.commentView.hidden = NO;
        NSDictionary *cmtDict = topic.top_cmt.firstObject;
        self.commentContent.text = [NSString stringWithFormat:@"%@ : %@",cmtDict[@"user"][@"username"],cmtDict[@"content"]];
        
    } else {// 无内容
        self.commentView.hidden = YES;
    }
    
    // 设置底部按钮内容
    [self setButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setButtonTitle:self.shareButton number:topic.repost placeholder:@"分享"];
    [self setButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
}

/**
 设置底部按钮内容

 @param titleBtn 按钮
 @param number 数量
 @param placeholder 默认文字
 */
- (void)setButtonTitle:(UIButton *)titleBtn number:(NSInteger)number placeholder:(NSString *)placeholder {

    if (number >=1000 ) {
        CGFloat numFinal = number / 1000.0;
        NSString *numStr = [NSString stringWithFormat:@"%.1fk",numFinal];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [titleBtn setTitle:numStr forState:UIControlStateNormal];
    }else if (number > 0 ) {
        [titleBtn setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }else {
        [titleBtn setTitle:placeholder forState:UIControlStateNormal];
    }
}


@end

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

@end


@implementation SYDTopicCell

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

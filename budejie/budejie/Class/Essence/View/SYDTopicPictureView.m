//
//  SYDTopicPictureView.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicPictureView.h"
#import "SYDTopicModel.h"
#import "UIImageView+SYDImageCache.h"
#import "SYDShowBigPictureViewController.h"

@interface SYDTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *showBigImageBtn;

@end
@implementation SYDTopicPictureView
- (IBAction)tapToShowBigPicture:(UITapGestureRecognizer *)sender {
    // 创建查看大图页面控制器
    SYDShowBigPictureViewController *showBigPicVC = [[SYDShowBigPictureViewController alloc] init];
    showBigPicVC.topic = self.topic;
    // 跳转至查看大图页面
    // 1.拿到当前视图的根控制器
    [self.window.rootViewController presentViewController:showBigPicVC animated:YES completion:^{
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(SYDTopicModel *)topic {
    _topic = topic;
    
    // 下载并显示图片
    
    UIImage *placeholderImage = [UIImage imageNamed:@"mainCellBackground.png"];
    [self.pictureView SYD_downLoadOriginImage:topic.image1 thumbbailImage:topic.image0 placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return ;
        }
    }];
    
//    if (!topic.is_gif) {
//        self.gifView.hidden = YES;
//    }
    self.gifView.hidden = !topic.is_gif;
    
    if(topic.isBigImage ) {
        self.showBigImageBtn.hidden = NO;
        self.pictureView.contentMode = UIViewContentModeTop;
        self.pictureView.clipsToBounds = YES;
        
        // 超长图片处理
        if (self.pictureView.image) {
            CGFloat imageW = self.pictureView.bounds.size.width;
            CGFloat imageH = topic.height * imageW / topic.width;
            
            // 开启图形上下文绘制图片
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0);
            [self.pictureView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            
            // 取出图形上下文图片
            self.pictureView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // 关闭图形上下文
            UIGraphicsEndImageContext();
            
        }
        
    }else {
        self.showBigImageBtn.hidden = YES;
        self.pictureView.contentMode = UIViewContentModeScaleToFill;
        self.pictureView.clipsToBounds = NO;
    }
    
}

@end

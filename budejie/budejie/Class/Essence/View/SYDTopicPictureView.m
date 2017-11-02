//
//  SYDTopicPictureView.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicPictureView.h"
#import "SYDTopicModel.h"
#import "UIView+frame.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "UIImageView+SYDImageCache.h"
#import "SYDShowBigPictureViewController.h"

@interface SYDTopicPictureView ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *showBigImageBtn;

@end
@implementation SYDTopicPictureView
{
    NSString * _url;
}

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
    _url = @"";
    self.pictureView.animatedImage = nil;
    self.pictureView.image = nil;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"mainCellBackground.png"];
    // 下载并显示图片

    [self.pictureView SYD_downLoadOriginImage:topic.image1 thumbbailImage:topic.image0 placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
                return ;
        }
        
        if ([topic.image1.pathExtension.lowercaseString isEqualToString:@"gif"]) {
            _url = topic.image1;
            [self tg_gifForUrl:_url];
        }
        
    }];

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
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), 0,[UIScreen mainScreen].scale);
            [self.pictureView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            
            // 取出图形上下文图片
            self.pictureView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // 关闭图形上下文
            UIGraphicsEndImageContext();
            
        }
        
    }else  {
        self.showBigImageBtn.hidden = YES;
        self.pictureView.contentMode = UIViewContentModeScaleToFill;
        self.pictureView.clipsToBounds = NO;
    }
    
    
}


- (void)tg_gifForUrl:(NSString*)url{
    id obj = [[self getCache] objectForKey:url];
    if (obj != nil ) {
        self.pictureView.animatedImage= (FLAnimatedImage*)obj;
        //TGLog(@"缓存中的 -- %@",url);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FLAnimatedImage *flImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [[self getCache] setObject:flImage forKey:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            //TGLog(@"下载的 -- %@",url);
            if (_url == url){
                self.pictureView.animatedImage= flImage;
            }else{
                //TGLog(@"# 错位了 不用设置gif（重用机制造成的，原理请参考SDWebImage）#");
            }
        });
    });
}

- (NSCache*)getCache{
    static NSCache * cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc]init];
        cache.countLimit = 30;//关键
        //TGLog(@"-- 自己的缓存策略 --");
    });
    return cache;
}

@end

//
//  SYDTopicModel.h
//  budejie
//
//  Created by mymac on 2017/10/10.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SYDTopicCellType) {
    SYDTopicTypeAll = 1,
    SYDTopicTypePicture = 10,
    SYDTopicTypeJoke    = 29,
    SYDTopicTypeVoice   = 31,
    SYDTopicTypeVideo   = 41
};

@interface SYDTopicModel : NSObject

/* 用户的名字 */
@property (nonatomic, copy) NSString *name;
/* 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/* 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/* 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/* 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/* 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/* 转发/分享数量 */
@property (nonatomic, assign) NSInteger repost;
/* 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/* 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;
/* 图片或视频的高度 */
@property (nonatomic, assign) CGFloat height;
/* 图片或视频的宽度 */
@property (nonatomic, assign) CGFloat width;

/* 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/* 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/* 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;

/* 音频播放地址 */
@property (nonatomic, copy) NSString *voiceuri;
/* 视频播放地址 */
@property (nonatomic, copy) NSString *videouri;

/* 缩略图地址地址 */
@property (nonatomic, copy) NSString *image0;
/* 中等图地址 */
@property (nonatomic, copy) NSString *image1;
/* 高清图地址 */
@property (nonatomic, copy) NSString *image2;

/* 判断是否是gif */
@property (nonatomic, assign) BOOL is_gif;
/* 判断是否是大图 */
@property (nonatomic, assign) BOOL isBigImage;

/* 帖子类型 */ //10为图片，29为段子，31为音频，41为视频，默认为1
@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, assign) NSUInteger cellHeight;
/* 中间视频图片部分的frame */
@property (nonatomic, assign) CGRect middleFrame;
@end

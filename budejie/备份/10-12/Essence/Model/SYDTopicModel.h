//
//  SYDTopicModel.h
//  budejie
//
//  Created by mymac on 2017/10/10.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SYDTopicCellType) {
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

/* 帖子类型 */ //10为图片，29为段子，31为音频，41为视频，默认为1
@property (nonatomic, assign) NSUInteger type;


@end

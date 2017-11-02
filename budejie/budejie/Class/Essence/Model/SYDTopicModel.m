//
//  SYDTopicModel.m
//  budejie
//
//  Created by mymac on 2017/10/10.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicModel.h"

@implementation SYDTopicModel

- (NSUInteger)cellHeight {
    
    if (_cellHeight == 0) {
        // 顶部文本的值
        _cellHeight += 65;
        
        // 中间文字的值
        CGSize texMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
        _cellHeight += [self.text boundingRectWithSize:texMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + 15;
        
        if (self.type != SYDTopicTypeJoke) {
            
            // 中间图片视频等高度
            CGFloat imageW = texMaxSize.width;
            CGFloat imageH = self.height * imageW / self.width;
            // 如果图片高度超过300，则设置成300
            
            if (imageH > [UIScreen mainScreen].bounds.size.height && !_is_gif) {
                imageH = 300;
                self.isBigImage = YES;
            }
            // 传递中间部分的frame值
            _middleFrame = CGRectMake(10, _cellHeight, imageW, imageH);
            
            
            // 增加中间部分的高度
            _cellHeight += imageH + 10;
        }
        
        // 最热评论部分高度
        if(self.top_cmt.count > 0){
            // 最热评论文字的高度
            NSDictionary *cmtDict = self.top_cmt.firstObject;
            NSString *topCmtContent = cmtDict[@"content"];
            _cellHeight += [topCmtContent boundingRectWithSize:texMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + 20;
        }
        
        // 底部工具条的高度
        _cellHeight += 35 + 10;
    }
    return _cellHeight;
}
@end

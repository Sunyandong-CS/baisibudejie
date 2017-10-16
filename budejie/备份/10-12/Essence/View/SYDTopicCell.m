//
//  SYDTopicCell.m
//  budejie
//
//  Created by mymac on 2017/10/11.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicCell.h"
#import "SYDTopicModel.h"

@implementation SYDTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置头部 控件
        
        // 设置底部 控件
    }
    return self;
}

- (void)setTopic:(SYDTopicModel *)topic {
    _topic = topic;
    
    // 设置头部和底部内容数据
    
}


@end

//
//  SYDTopicCell.h
//  budejie
//
//  Created by mymac on 2017/10/11.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYDTopicModel;

@interface SYDTopicCell : UITableViewCell

/*Topic模型属性*/
@property (nonatomic, strong) SYDTopicModel *topic;

/* 跳转到comment的block */
@property (nonatomic, copy) void (^commentBlock)(void);
@end

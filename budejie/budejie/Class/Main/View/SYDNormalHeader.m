//
//  SYDNormalHeader.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/31.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDNormalHeader.h"

@implementation SYDNormalHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置header的属性
        // 设置状态文字颜色
        self.stateLabel.textColor = [UIColor blueColor];
        self.stateLabel.font = [UIFont systemFontOfSize:17];
        [self setTitle:@"继续下拉刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在拼命刷新..." forState:MJRefreshStateRefreshing];
        // 隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}
@end

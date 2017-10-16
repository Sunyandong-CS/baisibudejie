//
//  SYDTabBar.m
//  budejie
//
//  Created by mymac on 2017/9/5.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTabBar.h"
#import "SYDPublishViewController.h"


#define TabBarButtonDidRepeatClickNotification @"TabBarButtonDidRepeatClickNotification"

@interface SYDTabBar ()
@property (nonatomic, assign) BOOL isRepeatClick;
/*纪录上一次点击的按钮*/
@property (nonatomic, weak) UIButton *preClickBtn;
@end

@implementation SYDTabBar

- (UIButton *)addbtn {
    if (_addbtn == nil) {
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        
        // 根据内容调整自适应
        [addBtn sizeToFit];
        [addBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        
        _addbtn = addBtn;
    }
    return _addbtn;
}

// 打开发布页面
- (void)publish {
    
    // 判断是否响应代理方法
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1.设置按钮排列
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnW = self.bounds.size.width / (self.items.count + 1);
    NSInteger i = 0;
    CGFloat btnX = 0;

    for (UIControl *btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 处理第一个页面的tabbar按钮的双击刷新事件,由于layoutSubViews可能被重写很多次，所以要判断是不是第一次给preClickButton赋值
            if (i == 0 && _preClickBtn == nil) {
                _preClickBtn = (UIButton *)btn;
            }
            
            if (i == 2) {
                i ++;
            }
            btnX = i * btnW;
            btn.frame = CGRectMake(btnX, 0, btnW, btnH);
            i++;
        
            [btn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    // 设置发布按钮的位置
    self.addbtn.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)tabBarBtnClick:(UIButton *)tabBarBtn {
    
    
    // 处理双击 上一次点击和本次点击的按钮相同则为两次点击,
    
    if (tabBarBtn == _preClickBtn) {
        // 发出通知,让相应页面接收通知执行刷新请求
        [[NSNotificationCenter defaultCenter] postNotificationName:TabBarButtonDidRepeatClickNotification object:nil];
    }
    _preClickBtn = tabBarBtn;
}


@end

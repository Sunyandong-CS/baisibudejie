//
//  SYDPublishView.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/26.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDPublishView.h"
#import "UIView+Animation.h"
#import "SYDButton.h"
#import "UIView+frame.h"

@implementation SYDPublishView
- (IBAction)cancel:(UIButton *)sender {
    
    
    [self viewClose:self animate:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加按钮
    [self addButton];
}

- (void)addButton {
    
    NSArray *buttons = @[@"发视频",@"发图片",@"发段子",@"发声音",@"发链接",@"发音乐相册"];
    NSArray *images = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-link",@"publish-review"];
    
    /* 按钮属性 */
    NSInteger count = 3;
    CGFloat btnMargin = 20;
    CGFloat marginY = 200;
    CGFloat buttonW = ([UIScreen mainScreen].bounds.size.width - (count+1) * btnMargin) / count ;
    CGFloat buttonH = buttonW;
    CGFloat btnY = 0;
    CGFloat BtnX = 0;
    for (NSInteger i = 0;i < buttons.count ; i++) {
        // 创建button
        btnY = i / count * buttonH + btnMargin * 2;
        BtnX = buttonW * (i % count) + (i % count + 1) * btnMargin;
        SYDButton *button = [SYDButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:buttons[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag = i;
        // 添加点击事件
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake( BtnX ,btnY + marginY , buttonW,buttonH);
        // 设置button的frame
        
        button.transform = CGAffineTransformMakeTranslation(0, -1000);
        // 动态添加按钮
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransformIsIdentity(button.transform);
        }];
        
        [self addSubview:button];
    }
    
}


- (void)btnClick:(SYDButton *)button {
    
    NSLog(@"%li",(long)button.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end

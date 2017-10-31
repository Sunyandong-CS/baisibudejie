//
//  UIView+Animation.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/27.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
- (void)popView:(UIView *)view animated:(BOOL)animated {
    // 保存当前弹出的视图
    CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;
    // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    view.center = screenCenter;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:view];
    
    if (animated) {
        // 第一步：将view宽高缩至无限小（点）
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity,CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3 animations:^{
            // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                // 第三步： 以动画的形式将view恢复至原始大小
                view.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)viewClose:(UIView *)view animate:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            }completion:^(BOOL finished) {
                // 第三步： 移除
                [view removeFromSuperview];
            }];
        }];
    } else {
        [view removeFromSuperview];
    }
}

@end

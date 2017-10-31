//
//  UIView+Animation.h
//  budejie
//
//  Created by 孙艳东 on 2017/10/27.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
- (void)popView:(UIView *)view animated:(BOOL)animated;
- (void)viewClose:(UIView *)view animate:(BOOL)animated;
@end

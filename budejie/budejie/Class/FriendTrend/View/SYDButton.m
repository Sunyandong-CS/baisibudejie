//
//  SYDButton.m
//  budejie
//
//  Created by mymac on 2017/9/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDButton.h"
#import "UIView+frame.h"

@implementation SYDButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片的位置
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置按钮文字label的位置
    self.titleLabel.y = self.height - self.titleLabel.height;
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.centerX = self.width * 0.5;
}

@end

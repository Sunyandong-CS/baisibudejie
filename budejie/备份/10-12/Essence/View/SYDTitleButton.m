//
//  SYDTitleButton.m
//  budejie
//
//  Created by mymac on 2017/9/25.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTitleButton.h"

@implementation SYDTitleButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 重写
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    // 重写set方法，取消高亮
}



@end

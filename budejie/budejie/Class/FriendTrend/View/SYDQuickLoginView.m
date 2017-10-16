//
//  SYDQuickLoginView.m
//  budejie
//
//  Created by mymac on 2017/9/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDQuickLoginView.h"

@implementation SYDQuickLoginView

+ (instancetype)loadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

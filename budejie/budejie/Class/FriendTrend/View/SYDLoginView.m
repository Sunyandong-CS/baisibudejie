//
//  SYDLoginView.m
//  budejie
//
//  Created by mymac on 2017/9/16.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDLoginView.h"

@interface SYDLoginView ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end


@implementation SYDLoginView

// 加载登陆View
+ (instancetype)loadLoginView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

// 加载注册View
+(instancetype)loadRegisterView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 获取当前背景图片
    UIImage *image = self.LoginBtn.currentBackgroundImage;
    
    // 设置图片不拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 加载图片
    [_LoginBtn setBackgroundImage:image forState:UIControlStateNormal];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

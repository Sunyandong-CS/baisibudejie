//
//  SYDLoginViewController.m
//  budejie
//
//  Created by mymac on 2017/9/16.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDLoginViewController.h"
#import "SYDLoginView.h"
#import "SYDQuickLoginView.h"
#import "UIView+frame.h"
@interface SYDLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginCons;
@property (weak, nonatomic) IBOutlet UIView *quickLoginV;

@end

@implementation SYDLoginViewController
- (IBAction)register:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.loginCons.constant = self.loginCons.constant == 0 ? -self.loginView.width * 0.5:0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    // 判断当前是哪个View，做旋转操作
    
    
}

- (IBAction)backBtn:(UIButton *)sender {
    // 返回道上一级页面
    [self dismissViewControllerAnimated:self completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加自定义登陆view
    [self addLoginView];
}

- (void)addLoginView {
    
    // 登陆部分View
    SYDLoginView *loginV = [SYDLoginView loadLoginView];
    [self.loginView addSubview:loginV];
    
    
    // 注册部分View
    SYDLoginView *registerV = [SYDLoginView loadRegisterView];
    
    [self.loginView addSubview:registerV];
    
    // 快速登录部分View
    SYDQuickLoginView *quickLoginV = [SYDQuickLoginView loadView];
    
    [self.quickLoginV addSubview:quickLoginV];
    
    
    // 设置选中文本框时的光标和字体颜色=======由于多处用到，选择自定义文本框，比较合适
    
}


// 添加View时重新设置下View的Frame
- (void)viewDidLayoutSubviews {
    // 登陆部分View的Frame
    SYDLoginView *loginV = self.loginView.subviews[0];
    loginV.frame = CGRectMake(0, 0, self.loginView.width * 0.5, self.loginView.height);
    
    
    // 注册部分View的Frame
    SYDLoginView *registerV = self.loginView.subviews[1];
    registerV.frame = CGRectMake(self.loginView.width * 0.5, 0, self.loginView.width * 0.5, self.loginView.height);
    
    // 快速登录部分Frame
    SYDQuickLoginView *quickLoginV = self.quickLoginV.subviews[0];
    quickLoginV.frame = CGRectMake(0, 0, self.quickLoginV.width, self.quickLoginV.height);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

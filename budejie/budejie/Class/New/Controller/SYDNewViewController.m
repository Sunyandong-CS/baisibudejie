//
//  SYDNewViewController.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDNewViewController.h"
#import "SYDSubscribeViewController.h"
#import "UIBarButtonItem+item.h"

@interface SYDNewViewController ()

@end

@implementation SYDNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    // Do any additional setup after loading the view.
}

- (void)setUpNavBar {
    // 设置左边按钮
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"MainTagSubIcon" AndHighlightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)]];
    
    // 2.设置标题图片
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]]];
    
}

// 按钮点击跳转
- (void)tagClick {
    SYDSubscribeViewController *subVc = [[SYDSubscribeViewController alloc] init];
    
    [self.navigationController pushViewController:subVc animated:YES];
    
    NSLog(@"%s",__func__);
}

@end

//
//  SYDNavigationController.m
//  budejie
//
//  Created by mymac on 2017/9/6.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDNavigationController.h"
#import "UIBarButtonItem+item.h"

@interface SYDNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation SYDNavigationController

+(void)load {
//    [super load];
//    NSLog(@"SYD----load");
    UINavigationBar *navbar = [UINavigationBar appearanceWhenContainedIn:self, nil] ;
    
//    navbar.barTintColor = [U  IColor]
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navbar setTitleTextAttributes:textAttrs];
    [navbar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}



// 重写Push方法，设置统一返回按钮，当创建导航控制器添加子控制器的时候调用，所以在添加子控制之前修改返回按钮样式即可
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"%s",__func__);
    
    // 当不是根控制器的时候就会给Push的子控制器添加返回按钮
    if (self.childViewControllers.count > 0) {
        // 恢复滑动返回功能：？ 因为覆盖了系统的按钮 ---》手势失效  :代理设置了不能滑动返回，需要设置代理判断什么时候滑动返回
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem navBackButtonWithImage:@"navigationButtonReturn" AndHighlightImage:@"navigationButtonReturnClick" target:self action:@selector(back) title:@"返回"];
//        NSLog(@"%@",self.interactivePopGestureRecognizer);
    }
    
    // 真正执行跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加全屏滑动手势5 
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark ----UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
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

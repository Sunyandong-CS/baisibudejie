//
//  SYDTabViewController.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTabViewController.h"
#import "SYDEssenceViewController.h"
#import "SYDPublishViewController.h"
#import "SYDMeViewController.h"
#import "SYDNewViewController.h"
#import "SYDFriendTrendViewController.h"
#import "SYDTabBar.h"
#import "UIImage+SYDImage.h"
#import "SYDNavigationController.h"

@interface SYDTabViewController ()<PublishButtonDelegate>

@end

@implementation SYDTabViewController

// 设置tabBar选中字体颜色
+ (void)load {
    
//    NSLog(@"--------laod------");
    // 获取整个应用程序下的UITabBarItem
    // UITabBarItem *tabBar = [UITabBarItem appearance];
    
    /*可背经历 bug  项目中导航条样式一致，就使用[UInavigationBar apperence]设置了统一样式，然后有发短信功能，发现系统样式被改，导致联系人显示不出来，使用appearanceWhenContainedIn方法解决了*/
    
    //
    UITabBarItem *tabBar = [UITabBarItem appearanceWhenContainedIn:self, nil];
    // 设置按钮选中字体颜色
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBar setTitleTextAttributes:attribute forState:UIControlStateSelected];
    
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabBar setTitleTextAttributes:attribute forState:UIControlStateNormal];
    
    
}

/*
 tabbar问题：
 1.图片被渲染，iOS7以后图片默认会被渲染------》解决方式：1.选中所有图片，在配置中修改 2.通过代码设置[ image imageWithRenderingMode:]
 2.字体颜色：添加字体属性
 3.发布按钮显示错误：图片大小问题，------> 设置图片偏移方式虽然可以用，但无法达到目的效果，需要自定义tabBar来实现按钮高亮
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.添加子控制器
    [self setUpAllChildViewController];
    
    // 2.设置tabBar按钮
    [self setUpAllTabBarButton];
    
    // 3.自定义tabBar
    [self setUpTabBar];
}

/*
 * 使用自定义TabBar
 */
- (void)setUpTabBar {
    
    SYDTabBar *tabBar = [[SYDTabBar alloc] init];
    // 使用KVC设置tabViewController中的属性tabbar的值为自定义tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    // self.tabBar.delegate = self;  tabbar 已经是自己的代理了
    
//    NSLog(@"%@",self.tabBar.class);
}

/*
    设置子控制器
 */
- (void)setUpAllChildViewController {
    
    // 1.创建子控制器 ---->创建导航控制器 ----> 设置导航控制器的子控制器---->添加子控制器
    
    // essence
    SYDEssenceViewController *essence = [[SYDEssenceViewController alloc] init];
    SYDNavigationController *nav = [[SYDNavigationController alloc] initWithRootViewController:essence];
    [self addChildViewController:nav];
    
    // new
    SYDNewViewController *new = [[SYDNewViewController alloc] init];
    SYDNavigationController *nav1 = [[SYDNavigationController alloc] initWithRootViewController:new];
    [self addChildViewController:nav1];
    
//    // publish --- 不需要导航控制器
//    SYDPublishViewController *publish = [[SYDPublishViewController alloc] init];
//    [self addChildViewController:publish];
    
    // FriendTrend
    SYDFriendTrendViewController *friendTrend = [[SYDFriendTrendViewController alloc] init];
    SYDNavigationController *nav2 = [[SYDNavigationController alloc] initWithRootViewController:friendTrend];
    [self addChildViewController:nav2];
    
    // me  修改从storyboard加载
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SYDMeViewController" bundle:nil];
    SYDMeViewController *me = [storyboard instantiateInitialViewController];
    
    SYDNavigationController *nav3 = [[SYDNavigationController alloc] initWithRootViewController:me];
    [self addChildViewController:nav3];
    
}

- (void)setUpAllTabBarButton {
    
    // 取出子控制器 --- 设置当前子控制器的tabBarItem
    
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    // 处理选中图片使其不渲染
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    // 处理选中图片使其不渲染
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    
//    SYDPublishViewController *publishVc = self.childViewControllers[2];
//    publishVc.tabBarItem.title = @"";
//    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    publishVc.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_publish_icon"];
//    // 处理选中图片使其不渲染
//    publishVc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_publish_click_icon"];
    
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"关注";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    // 处理选中图片使其不渲染
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    UINavigationController *nav3 = self.childViewControllers[3];
    nav3.tabBarItem.title = @"我的";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    // 处理选中图片使其不渲染
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
    
}

#pragma mark publish按钮点击代理方法

- (void)btnClick:(id)sender {
    
    
    NSLog(@"发布");
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

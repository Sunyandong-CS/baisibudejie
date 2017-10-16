//
//  SYDFriendTrendViewController.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDFriendTrendViewController.h"
#import "UIBarButtonItem+item.h"
#import "SYDLoginViewController.h"
#import "UITextField+placeholderColor.h"

@interface SYDFriendTrendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testLabel;

@end

@implementation SYDFriendTrendViewController

// 跳转至登陆页面
- (IBAction)goToLogin:(UIButton *)sender {
    SYDLoginViewController *loginVc = [[SYDLoginViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:^{
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    // 3.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    
    // 4.测试分类动能 ,顺序设置，不会有问体
//    self.testLabel.placeholder = @"123";
//    self.testLabel.placeholderColor = [UIColor redColor];

    /*
     *先设置颜色再设置文字，没有效果：原因，OC懒加载机制，当没有设置placeholder的时候，textfield内部的placeholderlabel不会生成，故颜色不能保存
     *解决办法，需要给textfeild添加一个保存颜色的属性---只能使用runtime
     */
    self.testLabel.placeholderColor = [UIColor redColor];
//    self.testLabel.placeholder = @"123";
    
    
    // 使用runtime的方法
//    [self.testLabel setSYD_Placeholder:@"123"];
    
    // 还可以使用交换方法来知己调用系统的set方法实现
    self.testLabel.placeholder = @"1234";
}

- (void)setUpNavBar {
    // 把按钮包装成View添加到navigationItem中,直接添加按钮会导致在导航栏其他地方也能点击，需要创建UIView 并添加Button才行
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"friendsRecommentIcon" AndHighlightImage:@"friendsRecommentIcon-click" target:self action:@selector(addAttention)]];

    // 2.设置标题图片
    [self.navigationItem setTitle:@"我的关注"];
    
}

// game按钮点击事件
- (void)addAttention {
    NSLog(@"%s",__func__);
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

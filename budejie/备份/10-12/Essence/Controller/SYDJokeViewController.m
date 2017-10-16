//
//  SYDJokeViewController.m
//  budejie
//
//  Created by mymac on 2017/9/26.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDJokeViewController.h"

static NSString *const ID = @"cell";
@interface SYDJokeViewController ()

@end

@implementation SYDJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 设置tableView的内边距，来达到cell全屏穿透效果
    self.tableView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 监听双击刷新操作
- (void)tabBarButtonClick {
    // 判断屏幕View是否包含当前页面
    if (!self.view.window) return;
    
    // 判断Veiw是否显示当前页面
    if (!self.tableView.scrollsToTop) return;
    
    // 执行刷新
    NSLog(@"刷新页面");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.class];
    
    return cell;
}

@end

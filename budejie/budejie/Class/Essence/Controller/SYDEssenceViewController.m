//
//  SYDEssenceViewController.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDEssenceViewController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+frame.h"
#import "SYDTitleButton.h"
#import "SYDAllViewController.h"
#import "SYDPictureViewController.h"
#import "SYDSoundViewController.h"
#import "SYDVideoViewController.h"
#import "SYDJokeViewController.h"



@interface SYDEssenceViewController ()<UIScrollViewDelegate>


/* 顶部视图 */
@property (nonatomic, weak) UIView *topView;
/* 保存ScrollView的所有视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
/* 底部条 */
@property (nonatomic, weak) UIView *titleUnderline;
/* 纪录前一个选中的按钮 */
@property (nonatomic, weak) SYDTitleButton *preSelbtn;
@end

@implementation SYDEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self addChildVC];
    
    // 1.添加左右两边按钮
    [self setUpNavBar];
    
    // 2.添加scrollView
    [self setUpScrollview];
    
    // 3.添加顶部导航View
    [self setUpTopNavView];
    
    // 4.默认加载"全部“页面的View
    [self loadOneChildViewWithIndex:0];

    #warning todo  tabbar和titleBtn的双击刷新
    
    #warning todo 上拉和下拉刷新
    
}

#pragma mark --- 初始化
- (void)setUpNavBar {
    // 把按钮包装成View添加到navigationItem中,直接添加按钮会导致在导航栏其他地方也能点击，需要创建UIView 并添加Button才行
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"nav_item_game_icon" AndHighlightImage:@"nav_item_game_click_icon" target:self action:@selector(game)]];
    
    // 添加UIView到navigationItem中
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"navigationButtonRandom" AndHighlightImage:@"navigationButtonRandomClick" target:self action:@selector(game)]];
    
    // 2.设置标题图片
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]]];

}

/**
 添加子控制器
 */
- (void)addChildVC {
    
    [self addChildViewController:[[SYDAllViewController alloc] init]];
    [self addChildViewController:[[SYDVideoViewController alloc] init]];
    [self addChildViewController:[[SYDSoundViewController alloc] init]];
    [self addChildViewController:[[SYDPictureViewController alloc] init]];
    [self addChildViewController:[[SYDJokeViewController alloc] init]];
    
}

- (void)setUpScrollview {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    
    
    // 设置ScrollView的滚动范围
    NSInteger count = self.childViewControllers.count;
    

    // 禁用ScrollView指示器
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.scrollsToTop  = NO;
    
    // scrollView.contentSize = CGSizeMake(self.view.width * 4, self.view.height);
    scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.delegate = self;
    
    // cell 穿透效果需要设置tableView的上下内边距,并且要设置tableView的尺寸和屏幕的尺寸一致
    CGFloat scrollViewW = scrollView.width;
//    CGFloat scrollViewH = scrollView.height;
    // 添加tableView
    
    
    /*
        由于self.childViewControllers[i].view;会加载所有的子控制器，会造成内存和资源的浪费，所有这里采用懒加载方式，
     
    */
//    for (NSInteger i = 0; i < count; i ++) {
//        
//        UIView *childView = self.childViewControllers[i].view;
//        
//        childView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        
//        [scrollView addSubview:childView];
//    }
//    
    scrollView.contentSize = CGSizeMake(scrollViewW * count, 0);
}

- (void)setUpTopNavView {
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 64, self.view.width, 40);
    
    _topView = topView;
    [topView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [self.view addSubview:topView];
    
    // 1.添加导航视图内部按钮
    [self setUpNavButton];
    
    // 2.添加底部条
    [self setupTitleUnderline];
}

/**
 *  标题下划线
 */
- (void)setupTitleUnderline
{
    // 标题按钮
    SYDTitleButton *firstTitleButton = self.topView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.height = 2;
    titleUnderline.y = self.topView.height - titleUnderline.height;
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.topView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
    
    // 切换按钮状态
    firstTitleButton.selected = YES;
    self.preSelbtn = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.titleUnderline.width = firstTitleButton.titleLabel.width;
    self.titleUnderline.centerX = firstTitleButton.centerX;
}




- (void)setUpNavButton {
    
    CGFloat BtnW = self.view.width / 5;
    
    // 按钮标题的数组
    NSArray *titleArr = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    for (NSInteger i = 0; i < 5; i ++) {
        SYDTitleButton  *topBtn = [SYDTitleButton buttonWithType:UIButtonTypeCustom];
        topBtn.frame = CGRectMake(i * BtnW, 0, BtnW, 40);
        topBtn.tag = i;
        // 添加按钮的点击事件
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:topBtn];
        
        // 设置按钮标题文字及样式
        [topBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [topBtn setTitle:titleArr[i] forState:UIControlStateSelected];
    }
    
}

#pragma  mark -响应事件

- (void)topBtnClick:(SYDTitleButton *)button {
    
    // 顶部按钮双击时发送刷新通知
    if (_preSelbtn == button) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleButtonDidRepeatClickNotification" object:nil];
    }
    
    // 处理标题按钮点击
    [self dealTopBtnClick:button];
}

/**
 处理标题按钮点击
 @param button 选中的标题按钮
 */

- (void)dealTopBtnClick:(SYDTitleButton *)button {
    _preSelbtn.selected = NO;
    button.selected = YES;
    _preSelbtn = button;
    
    
    // 按钮选中时移动底部条,动画效果
    [UIView animateWithDuration:0.3 animations:^{
        self.titleUnderline.width = button.titleLabel.width;
        self.titleUnderline.centerX = button.centerX;
        
        // 移动ScrollView的视图到相应位置
        _scrollView.contentOffset = CGPointMake(button.tag * self.view.width, 0);
        
    }completion:^(BOOL finished) {
        
        // 动画完成加载相应控制器的View
        NSUInteger  index = button.tag;
        [self loadOneChildViewWithIndex:index];
    }];
    
    // 设置当前显示的scrollVeiw 的 scrollstoTop 为YES
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i ++) {
        UIViewController *childVc = self.childViewControllers[i];
        
        // 如果View还没被创建，那就不用去管
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView =(UIScrollView *) childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == button.tag);
    }
    
    NSLog(@"第 %li 个按钮 ",(long)button.tag);
}

/**
 添加一个子控制器的View到ScrollView
 
 @param index 子控制器的索引
 */
- (void)loadOneChildViewWithIndex:(NSUInteger)index  {
    UIView *childView = self.childViewControllers[index].view;
    
    // 也可以用bounds
    // childView.frame = self.scrollView.bounds;
    
    childView.frame = CGRectMake(index * _scrollView.width, 0, _scrollView.width, _scrollView.height);
    [_scrollView addSubview:childView];
}

// game按钮点击事件
- (void)game {
    NSLog(@"%s",__func__);
}


#pragma mark UIScrollViewDelegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    // 选中需要点击的按钮
    
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    
    NSInteger index = offsetX / self.scrollView.width;
    SYDTitleButton *selectBtn = self.topView.subviews[index];
    
    [self dealTopBtnClick:selectBtn];
}

@end

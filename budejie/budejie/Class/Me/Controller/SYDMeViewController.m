//
//  SYDMeViewController.m
//  budejie
 //
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDMeViewController.h"
#import "UIBarButtonItem+item.h"
#import "SYDSettingViewController.h"
#import "SYDSquareCell.h"
#import <AFNetworking.h>
#import "SYDSquareItemModel.h"
#import <MJExtension/MJExtension.h>
#import <WebKit/WebKit.h>
#import "SYDWebViewController.h"

//#import <SafariServices/SafariServices.h>

static NSString *const ID =@"cell";
static NSInteger cols = 4;
static CGFloat margin = 1;

#define itemWH ([UIScreen mainScreen].bounds.size.width - (cols - 1) * margin) / cols

@interface SYDMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/*保存collectionView数据的数组*/
@property (nonatomic, strong) NSMutableArray *itemsArr;

/* 保存collectionView对象 */
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation SYDMeViewController

#pragma mark lazyload 
- (NSMutableArray *)itemsArr {
    if (_itemsArr == nil) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置导航栏
    [self setUpNavBar];

    // 2.设置底部footView
    [self setUpFootView];
    
    // 3.加载数据
    [self getCollectionViewData];
    
    // 4.修改tableViewcell分组之间的间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    // 第一个分组默认的Y值为35需要通过修改内边距来修改顶部高度
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}


/*
 *设置tableView的footView为collectionView
 */
- (void)setUpFootView {
    /*
     *使用collectionView注意事项
     *1. 使用流水布局
     *2. cell必须要注册
     *3. cell必须自定义
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置尺寸需要使用layout
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    
    
    // 保存创建的collectionView 以方便后面刷新
    self.collectionView = collectionView;
    
    
    self.tableView.tableFooterView = collectionView;
    collectionView.backgroundColor = self.tableView.backgroundColor;
    collectionView.scrollEnabled = NO;
    // 设置代理
    collectionView.delegate    = self;
    collectionView.dataSource  = self;
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"SYDSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    //    [collectionView registerClass:[SYDSquareCell class] forCellWithReuseIdentifier:ID];
}



#pragma mark 从服务器请求数据

- (void)getCollectionViewData {
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    // 3.发送请求（请求类型）
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        // 写数据到plist文件
        [responseObject writeToFile:@"/Users/mymac/Desktop/square.plist" atomically:YES];
        // 4.解析数据  字典数组转模型数组
        NSArray *items = responseObject[@"square_list"];
        _itemsArr = [SYDSquareItemModel mj_objectArrayWithKeyValuesArray:items];
        
        
        // 处理数据并添加空白格子填充
        [self resolveData];
        
        // 5.计算collectionView的高度
        CGFloat collectViewH = (_itemsArr.count - 1 ) / cols + 1;
        collectViewH = collectViewH * itemWH;
        self.collectionView.frame = CGRectMake(0, 0, 0, collectViewH);
        
        self.tableView.tableFooterView = self.collectionView;
        // 6.刷新数据
        [self.collectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/*
 * 处理最后一行剩余位置，使用空的cell填充
 */
- (void)resolveData {
    NSInteger count = self.itemsArr.count;
    NSInteger extra = count % cols;
    if (extra) {
        for (NSInteger i = 0; i < cols - extra; i ++) {
            SYDSquareItemModel *item = [[SYDSquareItemModel alloc] init];
            [self.itemsArr addObject:item];
        }
    }
}


- (void)setUpNavBar {
    // 把按钮包装成View添加到navigationItem中,直接添加按钮会导致在导航栏其他地方也能点击，需要创建UIView 并添加Button才行
    UIBarButtonItem *night = [UIBarButtonItem barButtonItemWithImage:@"mine-moon-icon" AndSelImage:@"mine-moon-icon-click" target:self action:@selector(btnSelect:)];
    
    // 添加UIView到navigationItem中
    UIBarButtonItem *setting = [UIBarButtonItem barButtonItemWithImage:@"mine-setting-icon" AndHighlightImage:@"mine-setting-icon-click" target:self action:@selector(setting)];
    
    self.navigationItem.rightBarButtonItems = @[setting,night];
    
    // 2.设置标题图片
    [self.navigationItem setTitle:@"我的"];
    
}

#pragma mark UIConllectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转界面  1. 使用safari跳转  2.使用webView  3.s使用框架SafariServices ios9之后  4.使用WK
    
    SYDSquareItemModel *item = self.itemsArr[indexPath.row];
    
    // 判断是否是http链接
    if (![item.url containsString:@"http"]) return;
    /* 使用SafariServices方法跳转 */
//    SFSafariViewController *sfVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
//    sfVc.navigationItem.backBarButtonItem.title = @"返回";
//    
//    // 跳转
//    [self presentViewController:sfVc animated:YES completion:^{
//        
//    }];
    /* 使用WKWebView 自定义ViewController 跳转后添加，这里只用传递参数 */
    SYDWebViewController *webVc = [[SYDWebViewController alloc] init];
    webVc.url = item.url;
    [self.navigationController pushViewController:webVc animated:YES];
    
    
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  self.itemsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 使用注册的cell
    SYDSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 拿到请求的Cell 并设置cell 的属性
    cell.item = self.itemsArr[indexPath.row];
    
    return cell;
}


- (void)btnSelect:(UIButton *)button {
    button.selected = !button.selected;
}

// setting按钮点击事件
- (void)setting {
    
    SYDSettingViewController *settingVc = [[SYDSettingViewController alloc] init];
    
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
    
}

@end

//
//  SYDTopicViewController.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/26.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

//
//  SYDAllViewController.m
//  budejie
//
//  Created by mymac on 2017/9/26.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTopicViewController.h"
#import "UIView+frame.h"
#import <AFNetworking.h>
#import "SYDTopicModel.h"
#import <FLAnimatedImage.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD.h>
#import "SYDTopicCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "SYDConst.h"
#import "SYDNormalHeader.h"
#import "SYDCommentViewController.h"


@interface SYDTopicViewController ()
/*统计数据量*/
@property (nonatomic, assign) NSInteger dataCount;
/*保存服务器返回的数据*/
@property (nonatomic, strong) NSMutableArray<SYDTopicModel *> *topicArr;
/*上拉刷新终止时间*/
@property (nonatomic, copy) NSString *maxtime;
/*AFN请求管理者对象*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/*缓存cell的高度*/
@property (nonatomic, strong) NSMutableDictionary *cellDict;
@end

@implementation SYDTopicViewController
{
    CGFloat _contentOffsetY;//上次的offset
    CGFloat _contentOffsetSpeed;//与上次的滚差，用于判断速度
    NSString * _np;
}

static NSString *const SYDTopicCellId = @"SYDTopicCellId";

- (SYDTopicCellType)type {
    return 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 设置tableView的内边距，来达到cell全屏穿透效果
    self.tableView.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // 设置滚动条的内边距，保证跟tableView的一致
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 处理上拉刷新，和下拉刷新,
    [self setUpHeaderAndFooterView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYDTopicCell class]) bundle:nil] forCellReuseIdentifier:SYDTopicCellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonClick) name:@"TitleButtonDidRepeatClickNotification" object:nil];
    
    
    // 进入页面立即刷新
    [self.tableView.mj_header beginRefreshing];
    
}


// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpHeaderAndFooterView {
    
    // 上拉刷新初始化
    [self setUpFooter];
    
    // 下拉刷新初始化
    [self setUpHeader];
}



- (void)setUpHeader {
    // 通过添加子View来达到下拉刷新显示内容目的
    
    /* 使用自定义header，子类化MSrefresh */
    self.tableView.mj_header = [SYDNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

}


- (void)setUpFooter {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

#pragma mark 监听双击刷新操作
- (void)tabBarButtonClick {
    // 判断屏幕View是否包含当前页面
    if (!self.view.window) return;
    
    // 判断Veiw是否显示当前页面
    if (!self.tableView.scrollsToTop) return;
    
    // 执行刷新
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)titleButtonClick {
    // 判断屏幕View是否包含当前页面
    if (!self.view.window) return;
    
    // 判断Veiw是否显示当前页面
    if (!self.tableView.scrollsToTop) return;
    
    // 执行刷新
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


/**
 返回每一个cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    SYDTopicModel *topic = self.topicArr[indexPath.row];
    
    return self.topicArr[indexPath.row].cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 根据数据量显示或隐藏footer
//    self.footer.hidden = (self.topicArr.count == 0);
    
    return self.topicArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYDTopicModel *topic = self.topicArr[indexPath.row];
    
    SYDTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:SYDTopicCellId];
    cell.topic = topic;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    [cell setCommentBlock:^() {
        SYDCommentViewController *cmtVC = [[SYDCommentViewController alloc] init];
        weakCell.topic = weakSelf.topicArr[indexPath.row];
        cmtVC.topic = weakCell.topic;
        [weakSelf .navigationController pushViewController:cmtVC animated:YES];
    }];
    
    return cell;
}


#pragma mark 加载数据

/**
 *加载新数据
 */
- (void)loadNewData {
    // 向服务器请求数据,使用AFN
    
    // 解决上下拉共存的方法2，取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    
    //    // 1.创建请求管理者对象
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    self.manager = mgr;
    
    // 2.设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    // 3.发送请求
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        //        [responseObject writeToFile:@"/Users/SYD/Desktop/topic/topic.plist" atomically:YES];
        // 字典数组-->模型数组 -- 自定义模型
        self.topicArr = [SYDTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 刷新数据
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务引起的的失败，而是网络或者其他问题
            [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *上拉加载更多数据
 */
- (void)loadMoreData {
    // 从服务器请求数据，并刷新
    
    // 解决上下拉共存的方法2，取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 1.创建请求管理者对象
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @1;
    parameters[@"maxtime"] = self.maxtime;
    // 3.发送请求
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {

        // 字典数组-->模型数组 -- 自定义模型
        NSMutableArray *topicArr = [SYDTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        [self.topicArr addObjectsFromArray:topicArr];
        NSLog(@"%lu",(unsigned long)self.topicArr.count);

        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 刷新数据
        [self.tableView reloadData];

        // 结束上拉刷新
        [self.tableView.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务引起的的失败，而是网络或者其他问题
            [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
        }
        // 结束上拉刷新
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 监听scrollView的滑动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > _contentOffsetY){//上滚
        //TGLog(@"up %f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y > 0){
            //隐藏，放入nav
            //通知形式
            //TGLog(@"我要隐藏了～～～～～～～～～～～～ %f",scrollView.contentOffset.y);
            if((scrollView.contentOffset.y - _contentOffsetY) > _contentOffsetSpeed && _contentOffsetSpeed>10){//速度超过20隐藏
                //TGLog(@"~~~~~~~~~~~~~~~~~~~~~%f %f",scrollView.contentOffset.y - _contentOffsetY,_contentOffsetSpeed);//滚速递减则不再发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NavigationBarHiddenNotification object:nil userInfo:nil];
            }
            _contentOffsetSpeed = scrollView.contentOffset.y - _contentOffsetY;
        }
    }else{
        //显示，回归原位
        //通知形式
        //TGLog(@"dwon %f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y > 0){
            //TGLog(@"我要显示了^^^^^^^^^^^^^^^^^^^^ %f",scrollView.contentOffset.y);
            if (_contentOffsetY - scrollView.contentOffset.y > _contentOffsetSpeed && _contentOffsetSpeed>10){//速度超过20显示
                //TGLog(@"^^^^^^^^^^^^^^^^^^^^^^^%f %f",_contentOffsetY - scrollView.contentOffset.y,_contentOffsetSpeed);
                [[NSNotificationCenter defaultCenter] postNotificationName:NavigationBarShowNotification object:nil userInfo:nil];
            }
            _contentOffsetSpeed = _contentOffsetY - scrollView.contentOffset.y;
        }else if (fabs(scrollView.contentOffset.y) > NavMaxY && fabs(scrollView.contentOffset.y) < NavMaxY+TitleVH){
            NSLog(@"我要显示了^^^^^^^^^^^^^^^^^^^^ %f",scrollView.contentOffset.y);
            [[NSNotificationCenter defaultCenter] postNotificationName:NavigationBarShowNotification object:nil userInfo:nil];
        }
    }
    _contentOffsetY = scrollView.contentOffset.y;
    // 滑动时清空内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
}


//- (void)dealHeader {
//
//    if (self.isHeaderRefreshing) {
//        return;
//    }
//
//    CGFloat offsetY = -(self.tableView.contentInset.top + _header.height);
//    if (self.tableView.contentOffset.y <= offsetY ) {
//        // 更改label文字
//        self.headerlabel.text = @"松开立即刷新";
//    }else {
//        self.headerlabel.text = @"下拉可以刷新";
//    }
//}
//
//
//- (void)dealFooter {
//
//    // 如果当前页面没有数据
//    if (self.tableView.contentSize.height == 0) {
//        self.tableView.tableFooterView.hidden = YES;
//        return;
//    }
//    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
//    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.height;
//
//    // 进入刷新状态
//    if(self.tableView.contentOffset.y >= offsetY && self.tableView.contentOffset.y > -self.tableView.contentInset.top) {
//        [self footerStartRefresh];
//    }
//
//}

#pragma mark 开始上拉刷新


/**
 bug：由于用户网络或操作问题可能存在上拉刷新和下拉刷新并存的问题，解决方案：
 1.当正在上拉（或者下拉）时禁用下拉刷新（上拉刷新）---- 方法简单
 2.当执行上拉（或者下拉）时关闭当前正在运行的下拉刷新（上拉刷新）---- 方法复杂，但有相应用途
 */
//- (void)headerStartRefresh {
//
//    // 判断是否正在刷新，如果正在刷新则不执行任何操作
//    //    if (_isFooterRefreshing) return; // 方式一，解决上下拉共存的问题
//
//    // 判断是否正在刷新，如果正在刷新则不执行任何操作
//    if (_isHeaderRefreshing) return;
//
//    // 更改label文字
//    _isHeaderRefreshing = YES;
//    self.headerlabel.text = @"正在刷新数据...";
//    [UIView animateWithDuration:0.25 animations:^{
//        UIEdgeInsets inset = self.tableView.contentInset;
//
//        NSLog(@"%f %f",self.header.height,inset.top);
//
//        inset.top += self.header.height;
//        self.tableView.contentInset = inset;
//        NSLog(@"%f",inset.top);
//
//        // 修改偏移量，目的是当双击标题栏，或者tabbar 时可以出现刷新动画
//        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,  - inset.top);
//    }];
//
//    // 从服务器请求数据
//    [self loadNewData];
//
//}
//
//- (void)headerEndRefresh {
//
//    // 请求完成，处理
//    _isHeaderRefreshing = NO;
//    self.headerlabel.text = @"下拉可以刷新";
//    // 恢复内边距
//    [UIView animateWithDuration:0.25 animations:^{
//        UIEdgeInsets inset = self.tableView.contentInset;
//        inset.top -= self.header.height;
//        self.tableView.contentInset = inset;
//        //        _headerlabel.alpha = 0;
//    }];
//
//}
//
//#pragma mark 开始下拉刷新
//- (void)footerStartRefresh {
//    // 如果当前正在刷新，则不需要进行刷新
//    if (self.isFooterRefreshing) return;
//    // 判断是否正在刷新，如果正在刷新则不执行任何操作
//
//    // if (_isHeaderRefreshing) return;// 方式一，解决上下拉共存的问题
//
//    self.isFooterRefreshing = YES;
//    // 更改footView的内容
//    self.refreshLabel.text = @"正在刷新";
//    [self loadMoreData];
//
//}
//
//- (void)footerEndRefresh {
//
//    // 结束刷新
//    self.refreshLabel.text = @"继续上拉刷新";
//    self.isFooterRefreshing = NO;
//
//}

#pragma mark 初始化属性

/*
 *lazy load topicArr
 */

- (NSMutableArray *)topicArr {
    if (_topicArr == nil) {
        _topicArr = [NSMutableArray array];
    }
    return _topicArr;
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return  _manager;
}

- (NSMutableDictionary *)cellDict {
    if (_cellDict == nil) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
}

@end


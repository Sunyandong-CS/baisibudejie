//
//  SYDSettingViewController.m
//  budejie
//
//  Created by mymac on 2017/9/6.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDSettingViewController.h"
#import "FileCacheTool.h"
#import "UIView+frame.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define CacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

//#import "UIBarButtonItem+item.h"
static NSString *const ID = @"cell";

@interface SYDSettingViewController ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation SYDSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    [SVProgressHUD showInfoWithStatus:@"正在获取缓存大小..."];
    
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [FileCacheTool getFileSize:cachePath completion:^(NSInteger totalCount) {
        
        _totalSize = totalCount;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];

    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

// 自定义section的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 20)];
    
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, view.width, 15)];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:12];
    titleLable.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            titleLable.text = @"缓存管理";
            break;
        case 1:
            titleLable.text = @"数据列表";
            break;
    }
    [view addSubview:titleLable];
    
    return view;
}


// 返回头部视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return  20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",(long)section);
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 10;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
                cell.textLabel.text = [self formatFileSize];
            }
            break;
        case 1: {
                cell.textLabel.text = @"1-1-1";
            }
            break;
    }
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (NSString *)formatFileSize {

    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"清除缓存";
    if (totalSize > 1000 * 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,totalSize / 1000.0 / 1000.0];
    } else if (totalSize > 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,totalSize / 1000.0];
    } else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)",sizeStr,(long)totalSize];
    }
    return sizeStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [FileCacheTool removeDirectory:CacheDir];
        _totalSize = 0;
        [tableView reloadData];
    }
}




@end

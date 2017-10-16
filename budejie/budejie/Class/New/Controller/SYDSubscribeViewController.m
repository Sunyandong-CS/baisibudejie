//
//  SYDSubscribeViewController.m
//  budejie
//
//  Created by mymac on 2017/9/13.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDSubscribeViewController.h"
#import "SYDSubItem.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "SYDSubCell.h"


static NSString * const ID = @"cell";
@interface SYDSubscribeViewController ()<UITableViewDataSource>
/*保存请求的模型数组*/
@property (nonatomic, strong)NSMutableArray *subItem;
/*管理网络请求*/
@property (nonatomic, weak) AFHTTPSessionManager *manager ;
@end

@implementation SYDSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 请求数据
    [self getTableData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SYDSubCell" bundle:nil] forCellReuseIdentifier:ID];
    
    // 设置标题
    self.title = @"关注标签";
    
    // 设置cell底部横线全屏 1. 自定义 2.使用系统自带 3.万能方法: 清除系统样式，设置背景色，设置cell高度
    // self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    // 提示加载
    [SVProgressHUD showWithStatus:@"正在加载"];
    
}

- (void)getTableData {
    // 1.创建AFN请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _manager = manager;
    // 2.设置请求参数
    NSMutableDictionary *premeters = [NSMutableDictionary dictionary];
    premeters[@"a"] = @"tag_recommend";
    premeters[@"action"] = @"sub";
    premeters[@"c"] = @"topic";
    
    // 3.发送请求
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:premeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        // 需要的数据 image_list，sub_number，theme_name，is_sub
        NSLog(@"%@",responseObject.class);
        
        // 关闭提示
        [SVProgressHUD dismiss];
        
        NSArray *itemArr = responseObject;
        // 数组转模型
        _subItem = [SYDSubItem mj_objectArrayWithKeyValuesArray:itemArr];
        
        // 重新加载数据
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 关闭提示
        [SVProgressHUD dismiss];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    // 关闭提示
    [SVProgressHUD dismiss];
    
    // 取消网络请求
    
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *ID = @"cell";
    
    SYDSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    // 从xib加载自定义cell 第一种方式 === 第二种方式，注册 见ViewDidload
    // 注意 如果cell从Xib加载一定要绑定标示符  
//    if (cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"SYDSubCell" owner:nil options:nil].lastObject;
//    }
    
//    NSLog(@"%p",cell);
    
    SYDSubItem *item = self.subItem[indexPath.row];
    
    cell.item = item;
//    cell.textLabel.text = item.theme_name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

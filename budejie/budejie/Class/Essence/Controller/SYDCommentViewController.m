//
//  SYDCommentViewController.m
//  budejie
//
//  Created by 孙艳东 on 2017/11/1.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDCommentViewController.h"
#import "SYDTopicCell.h"
#import "SYDTopicModel.h"


static NSString * const ID = @"SYDTopicCell"; // 评论cell

@interface SYDCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UITextField *textFileld;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation SYDCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册TopicCell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYDTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.navigationItem.title = @"评论";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置tableView的顶部inset
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

#pragma mark -- UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"最热评论";
            break;
        case 2:
            return @"最新评论";
            break;
            
        default:
            return @"";
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    SYDTopicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    cell.topic = self.topic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.topic.cellHeight;
}


@end

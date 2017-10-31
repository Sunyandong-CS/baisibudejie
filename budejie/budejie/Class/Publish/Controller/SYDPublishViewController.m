//
//  SYDPublishViewController.m
//  budejie
//
//  Created by mymac on 2017/9/4.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDPublishViewController.h"

@interface SYDPublishViewController ()

@end

@implementation SYDPublishViewController
- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  SYDAdvertisementViewController.m
//  budejie
//
//  Created by mymac on 2017/9/7.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDAdvertisementViewController.h"
#import <AFNetworking.h>
#import "SYDAdModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SYDTabViewController.h"

/* 定义屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.height
/* 定义求请求参数 */
#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"


@interface SYDAdvertisementViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adView;
/*显示广告图片*/
@property (nonatomic, weak) UIImageView *adImageV;

/*保存请求的广告数据*/
@property (nonatomic, strong) SYDAdModel *adData;

/*计时器*/
@property (nonatomic, weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@end
@implementation SYDAdvertisementViewController

#pragma mark --- 懒加载

- (UIImageView *)adImageV {
    if (_adImageV == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 添加到控件上
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToAd)];
        [imageView addGestureRecognizer:tap];
        
        imageView.userInteractionEnabled = YES;
        [self.adView addSubview:_adImageV];
        
        _adImageV = imageView;
        
    }
    
    return _adImageV;
}

- (IBAction)jumpAdvertisement:(UIButton *)sender {
    // 销毁广告界面,进入主界面
    SYDTabViewController *tabVc = [[SYDTabViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
    // 销毁定时器
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLaunchImage];
    [self getAdInfo];
   
    // 创建一个跳转计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
}

- (void)countTime {
    static NSInteger i = 3;
    if (i == 0) {
        // 销毁广告界面,进入主界面
        SYDTabViewController *tabVc = [[SYDTabViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
        // 销毁定时器
        [self.timer invalidate];
    }
    i--;
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过 (%ld)",(long)i] forState:UIControlStateNormal] ;
}

- (void) setUpLaunchImage {
    // 屏幕适配
    /*
     *
     */
    NSLog(@"%f",ScreenW);
    if (ScreenW == 736) {// 6p 7p
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if(ScreenW == 667) { // 6 6s 7
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    } else if (ScreenW == 568) { // 5 5s se
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h@2x"];
    } else if (ScreenW == 480 ) { // 4s 4
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage@2x"];
    }

}

- (void) getAdInfo{
    
    // 1.创建请求对话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    // 3.发送请求
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSMutableDictionary  *_Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        // [responseObject writeToFile:@"/Users/mymac/Desktop/GCD/budejie/ad.plist" atomically:YES];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        // 4.获取广告数据 字典
        dict = [responseObject[@"ad"] lastObject];
        
        // 字典转模型 -->创建模型
        _adData = [SYDAdModel mj_objectWithKeyValues:dict];
        
        // 5.显示图片 通过url加载图片，SDWebImage ,创建ImageView
        
        // 设置广告的尺寸
        CGFloat adH =  ScreenW / _adData.w * _adData.h;
        
        self.adImageV.frame = CGRectMake(0, 0, ScreenW, adH);
        
        NSURL *adImageUrl = [NSURL URLWithString:_adData.w_picurl];

        [self.adImageV sd_setImageWithURL:adImageUrl];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
// 使用safari跳转
- (void)jumpToAd {
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:self.adData.ori_curl];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}

@end

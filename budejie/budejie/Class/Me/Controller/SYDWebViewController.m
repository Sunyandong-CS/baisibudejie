//
//  SYDWebViewController.m
//  budejie
//
//  Created by mymac on 2017/9/20.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+frame.h"
@interface SYDWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *containV;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;


@end

@implementation SYDWebViewController
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)forwardBtn:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
- (IBAction)refreshBtn:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建WebView
    [self setUpWebView];
}

- (void) setUpWebView {
    
    // 1.创建webView并加载url
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.containV.width, self.containV.height)];
    _webView = webV;
    [self.containV addSubview:webV];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    // 2.监听属性变化,KVO方法，记得移除
    [webV addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webV addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webV addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webV addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 监听变化，改变按钮状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.backItem.enabled = self.webView.canGoBack;
    self.forwardItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    
    // 设置进度条
    self.progress.progress = self.webView.estimatedProgress;
    self.progress.hidden = self.webView.estimatedProgress >= 1;
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end

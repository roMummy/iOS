//
//  YCWebViewController.m
//  ShecareSDKDemo-OC
//
//  Created by 罗培克 on 2018/3/19.
//  Copyright © 2018年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "YCWebViewController.h"
#import <WebKit/WebKit.h>

@interface YCWebViewController ()<WKNavigationDelegate>

@property(strong, nonatomic) WKWebView *webView;

@end

@implementation YCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}

#pragma mark - lazy load

-(WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end

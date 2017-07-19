//
//  DSWebViewController.m
//  SMSW
//
//  Created by 点石科技 on 16/6/4.
//  Copyright © 2016年 点石科技. All rights reserved.
//

#import "DSWebViewController.h"
#import "AppDelegate.h"
#import "RotateInterfaceOrientationTool.h"
#import <WebKit/WebKit.h>

@interface DSWebViewController ()<UIWebViewDelegate,WKNavigationDelegate>
{
//    UIWebView *_webView;
//    WKWebView *_wkWebView;
}
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) WKWebView *wkWebView;

@end

@implementation DSWebViewController

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];

}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.delegate = self;
                [self.view addSubview:_webView];

    }
    return _webView;
}


// 进入全屏
-(void)begainFullScreen
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
    delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskAllButUpsideDown;
//    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationLandscapeRight];

}
// 退出全屏
-(void)endFullScreen
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
    delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskPortrait;
     [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    


    
    NSURL *url = [NSURL URLWithString:self.urlString];
//    NSURL *url = [NSURL URLWithString:@"www.smqswj.gov.cn/app/view/officearticle/article-detail?id=195"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
        [self.webView loadRequest:request];
    
    
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获取当前的网页地址
    NSString *urlString = webView.request.URL.absoluteString;
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //获取当前的网页地址
    NSString *urlString = webView.request.URL.absoluteString;

    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
    if (self.title) {
        return;
    }
    
    
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = titleHtmlInfo;
    

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [DSHUD showfail:@"加载失败" view:self.view];
//    [SVProgressHUD showErrorWithStatus:@"加载失败"];

}



@end

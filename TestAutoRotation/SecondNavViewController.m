//
//  SecondViewController.m
//  TestAutoRotation
//
//  Created by DianShi on 17/07/2017.
//  Copyright © 2017 dzq. All rights reserved.
//

#import "SecondNavViewController.h"
#import "AppDelegate.h"
#import "RotateInterfaceOrientationTool.h"
#import "DSWebViewController.h"
@interface SecondNavViewController ()

@end

@implementation SecondNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *enterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [enterButton setTitle:@"Done" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:enterButton];
}
- (void)enterButtonClick:(id)sender{
    DSWebViewController *webVC = [[DSWebViewController alloc]init];
    webVC.urlString = @"http://www.baidu.com";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.allowRotate = 1;
//    delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskLandscapeRight;
    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 0;
//    delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskPortrait;
    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationPortrait];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 1;
//        delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskLandscapeRight;
//    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//    
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            delegate.allowRotate = 0;
//        delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskPortrait;
//    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationPortrait];
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    // NSLog(@"%d",[NSThread isMainThread]);
    // NSLog(@"%@",NSStringFromCGSize(size));
    // 记录当前是横屏还是竖屏
    
    // 翻转的时间
    CGFloat duration = [coordinator transitionDuration];
    [UIView animateWithDuration:duration animations:^{
        //转屏后刷新UI坐标
//        [self reloadLandscapeView:size];
    }];
    
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
        
        [super willTransitionToTraitCollection:newCollection
                     withTransitionCoordinator:coordinator];
        
//        [self reloadLandscapeView:CGSizeMake(MAX(self.view.frame.size.width, self.view.frame.size.height), MIN(self.view.frame.size.width, self.view.frame.size.height))];
}





- (BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

// 初始方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
// 如果需要横屏的时候，设置为NO，则不隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
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

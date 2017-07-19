//
//  TestRootViewController.m
//  TestAutoRotation
//
//  Created by DianShi on 19/07/2017.
//  Copyright © 2017 dzq. All rights reserved.
//

#import "TestRootViewController.h"
#import "RotateInterfaceOrientationTool.h"

@interface TestRootViewController ()

@end

@implementation TestRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试默认就是RootViewController的旋转情况";
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight]forKey:@"orientation"];

}

// 是否支持旋转
- (BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

// 如果是present方式 的默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

// 不隐藏状态栏
- (BOOL)prefersStatusBarHidden{
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

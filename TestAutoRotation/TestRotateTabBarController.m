//
//  TestRotateTabBarController.m
//  TestAutoRotation
//
//  Created by DianShi on 19/07/2017.
//  Copyright © 2017 dzq. All rights reserved.
//

#import "TestRotateTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
@interface TestRotateTabBarController ()

{
    BOOL __shouldAutorotate;
}
@end

@implementation TestRotateTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FirstViewController *first = [[FirstViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:first];
    nav1.tabBarItem.title = @"First";
    
    SecondViewController *second = [[SecondViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:second];
    nav2.tabBarItem.title = @"Second";
    
    
    self.viewControllers = @[nav1,nav2];
    
    
    //注册旋转屏幕的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autorotateInterface:) name:@"InterfaceOrientation" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)autorotateInterface:(NSNotification *)notifition
{
    
    __shouldAutorotate = [notifition.object boolValue];
    NSLog(@"接收到的通知>> %d", __shouldAutorotate);
}

/**
 *
 *  @return 是否支持旋转
 */
-(BOOL)shouldAutorotate
{
    
    NSLog(@"======>> %d", __shouldAutorotate);
    return __shouldAutorotate;
}

/**
 *  适配旋转的类型
 *
 *  @return 类型
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    if (!__shouldAutorotate) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
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

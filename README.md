# TestAutoRotation
# 关于横竖屏处理

本文整理关于iOS控制页面横竖屏的方案，iOS有两种支持屏幕旋转的实现方案：

## UIViewControllerRotation
```objective-c
@interface UIViewController (UIViewControllerRotation)中 （iOS 6.0+）
//Returns a Boolean value indicating whether the view controller's contents should auto rotate.
@property(nonatomic, readonly) BOOL shouldAutorotate; // 是否支持旋转
//Returns all of the interface orientations that the view controller supports.
@property(nonatomic, readonly) UIInterfaceOrientationMask  supportedInterfaceOrientations; //支持的方向
//Returns the interface orientation to use when presenting the view controller. 
@property(nonatomic, readonly) UIInterfaceOrientation  preferredInterfaceOrientationForPresentation; //应该意思是present情况默认方向（未验证）
```

1. 首先：这种实现方案，必须在项目General-Device Orientation中勾选相应支持的方向


![83D3944F-226D-4D72-9F4E-7225478443B8](/Users/DianShi/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/Users/343062356/QQ/Temp.db/83D3944F-226D-4D72-9F4E-7225478443B8.png)

2. 只有当shouldAutorotate为YES 的时候，才会进入判断supportedInterfaceOrientations。
3. 三个设置需要在项目的rootViewController（根视图）才有效：
- 如果项目的根视图是当前viewcontroller，直接在viewController内部重载这三个方法就能生效
```objective-c
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
```
- 如果项目的根视图是UINavigationController，则自定义一个UINavigationController

```objective-c
- (BOOL)shouldAutorotate{
    if ([self.topViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [self.topViewController shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}
```
然后在navigationController的相应ViewController中重写三个方法就能生效。如果在ViewController中不重写，则默认会根据项目General-Device Orientation中的设置，来判断是否支持旋转，及支持的旋转方向。

- 如果项目的根视图是UITabBarViewController，需要通过通知方式修改TabbarController的相关属性

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
  // ……
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
}

/**
 *
 *  @return 是否支持旋转
 */
-(BOOL)shouldAutorotate
{ 
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
```
在相应的ViewController的viewWillAppear，viewDidDisappear 发起通知。

## application:supportedInterfaceOrientationsForWindow:
这个方案，优先级高于UIViewControllerRotation：也就是在Appdelegate 重写这个方法后，则General-Device Orientation ，shouldAutorotate等设置都会不起作用。(对于整个应用只支持竖屏，个别页面需要横屏旋转，强烈建议用这个方案，对原有项目结构修改最小，而且方便控制)

`AppDelegate.h` 增加两个相关属性
```objective-c
@property (nonatomic,assign) UIInterfaceOrientationMask supportedInterfaceOrientationsForWindow;

@property (nonatomic,assign) BOOL allowRotate;
```
`AppDelegate.m` 中重写application:supportedInterfaceOrientationsForWindow:方法
```objective-c
////此方法会在设备横竖屏变化的时候调用
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotate == 1) {
        return _supportedInterfaceOrientationsForWindow;
    }
    return UIInterfaceOrientationMaskPortrait;
}

// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotate == 1) {
        return YES;
    }
    return NO;
}
```
在相应的ViewController的viewWillAppear，viewDidDisappear 发起通知。

```objective-c
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.allowRotate = 1;
        delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskLandscapeRight;
    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.allowRotate = 0;
        delegate.supportedInterfaceOrientationsForWindow = UIInterfaceOrientationMaskPortrait;
    [RotateInterfaceOrientationTool interfaceOrientation:UIInterfaceOrientationPortrait];
}
```



## 关于屏幕旋转后的界面适配
建议采用autoLayout的方式进行界面适配，如果是用frame控制，则需要在方法viewWillTransitionToSize:withTransitionCoordinator:( 如果是present 需要重写这个方法 willTransitionToTraitCollection:withTransitionCoordinator:) 中更新相关View的frame：

## 关于UIWebView视频播放横屏控制

webview所在的UIViewController 注册通知：

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
  // ……
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
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
```



> 写在最后： 建议在viewDidDisappear做还原操作，因为如果ViewWillDisAppear设置，会造成用侧滑手势返回的情况下页面错乱的情况。但ViewWillDisAppear中设置动画效果会比较好，如果要在ViewWillDisAppear设置，建议禁用侧滑返回手势:
>
>```objective-c
>viewDidAppear （经测试，如果在viewWillAppear控制，会造成push进入下级页面的返回手势受影响。不知道是不是系统bug ）
>// 禁用右滑pop手势
>self.navigationController.interactivePopGestureRecognizer.enabled = NO;
>self.navigationController.interactivePopGestureRecognizer.delegate = self;
>```

//
//  AppDelegate.h
//  TestAutoRotation
//
//  Created by DianShi on 17/07/2017.
//  Copyright © 2017 dzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) UIInterfaceOrientationMask supportedInterfaceOrientationsForWindow;

@property (nonatomic,assign) BOOL allowRotate;

@end


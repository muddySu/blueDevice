//
//  AppDelegate.h
//  blueDevice
//
//  Created by 苏小龙 on 14-6-21.
//  Copyright (c) 2014年 苏小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ViewController *viewController;
    UIActivityIndicatorView *myActivity;

}
@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic)UIActivityIndicatorView *myActivity;
//蓝牙操作
@property(strong,nonatomic)SerialGATT *sensor;
+(AppDelegate *)userInfo;

@end

//
//  WXC_AppDelegate.h
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *_rootNavigationController;
    MMDrawerController *_drawerController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) MMDrawerController *drawerController;

@end

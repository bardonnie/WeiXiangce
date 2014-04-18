//
//  WXC_AppDelegate.m
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_AppDelegate.h"

@implementation WXC_AppDelegate
{
    WXC_CoverImageView *_coverImageView;
    UIView *_defaultCoverView;
}

@synthesize rootNavigationController = _rootNavigationController;
@synthesize drawerController = _drawerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    NSLog(@"plst - %@",NETWORK_PLIST);
    
    [ShareSDK registerApp:@"1065f065e110"];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2340801140"
                               appSecret:@"4fa211cb9a2d028af394c94789b2853f"
                             redirectUri:@"http://www.panker.cn"];
    
    [ShareSDK connectQQWithQZoneAppKey:@"101006465"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQZoneWithAppKey:@"101006465" appSecret:@"f346f90a1c8c014806798c41ce2aca24"];
    
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectWeChatSessionWithAppId:@"wx98508367ffed97ec" wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatTimelineWithAppId:@"wx98508367ffed97ec" wechatCls:[WXApi class]];
    
    [ShareSDK importWeChatClass:[WXApi class]];
    
    [ShareSDK connectMail];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path - %@",paths);
    
    [[NetworkClass shareNetworkClass] downloadWizDataBase];
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:ADDALBUM_URL,KBGUID,STUDIO_NAME]];
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:ADDCUSTOMER_URL,KBGUID,USER_NAME,@"2"]];
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:STATISTICS_URL,KBGUID,@"-1",@"7"]];
    
    WXC_MainViewController *mainViewController = [[WXC_MainViewController alloc] init];
    mainViewController.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    WXC_MenuViewController *menuViewController = [[WXC_MenuViewController alloc] init];
    
    WXC_GrowingViewController *growingViewController = [[WXC_GrowingViewController alloc] init];
    
    _drawerController = [[MMDrawerController alloc] initWithCenterViewController:mainViewController leftDrawerViewController:menuViewController rightDrawerViewController:growingViewController];
    [_drawerController setMaximumLeftDrawerWidth:LEFT_CONTERLLER_WIDTH];
    [_drawerController setMaximumRightDrawerWidth:RIGHT_CONTERLLER_WIDTH];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_drawerController];
    _rootNavigationController.navigationBarHidden = YES;
    
    [self judgeIsFirst];
    [self showCoverImage];
    
    self.window.rootViewController = _rootNavigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)judgeIsFirst
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]/*如果不是第二次使用*/)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];//设置第二次使用的value值为yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];//设置第一次使用的value值为yes
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}

- (void)showCoverImage
{
    [_defaultCoverView removeFromSuperview];
    _coverImageView = [[WXC_CoverImageView alloc] init];
    
    if (MAIN_WINDOW_HEIGHT == 480)
    {
        [_coverImageView.backImageView setImage:[UIImage imageNamed:@"Image"]];
    }
    else
    {
        [_coverImageView.backImageView setImage:[UIImage imageNamed:@"Image_568"]];
    }
    
    _coverImageView.frame = CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT);
    [_coverImageView setAnimation:ButtonPressAnimate];
    [_rootNavigationController.view addSubview:_coverImageView];
}


- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive --1");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _defaultCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT)];
    _defaultCoverView.backgroundColor = [UIColor blackColor];
    [_rootNavigationController.view addSubview:_defaultCoverView];
    NSLog(@"applicationDidEnterBackground --2");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self showCoverImage];
    NSLog(@"applicationWillEnterForeground --3");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive --4");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate --5");
}

@end

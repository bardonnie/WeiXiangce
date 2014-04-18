//
//  WXC_MenuViewController.h
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#define PHONE_NUMBER        [STDUIO_DIC objectForKey:@"studio_number"]
#define STUDIO_NAME         [STDUIO_DIC objectForKey:@"studio_name"]
#define STUDIO_ABOUT        [STDUIO_DIC objectForKey:@"studio_about"]
#define STUDIO_RECOMM       [STDUIO_DIC objectForKey:@"studio_recomm"]
#define USER_NAME_PINYIN    [STDUIO_DIC objectForKey:@"name_pinyin"]
#define SHARE_TYPE          [STDUIO_DIC objectForKey:@"share_type"]
#define USER_NAME           [NETWORK_PLIST objectForKey:@"CFBundleDisplayName"]

#import <UIKit/UIKit.h>

@interface WXC_MenuViewController : UIViewController


@end

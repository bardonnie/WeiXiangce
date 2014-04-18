//
//  WXC_HeaderFileName.h
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//


#pragma mark - wizServer

#define NETWORK_PLIST       [[NSBundle mainBundle] infoDictionary]
#define STDUIO_DIC          [NETWORK_PLIST objectForKey:@"studio_info"]
#define NETWORK_PACKAGE     [[NetworkClass shareNetworkClass] findPackageFiles]

#define USER_ID     [STDUIO_DIC objectForKey:@"id"]
#define USER_PWD    [STDUIO_DIC objectForKey:@"password"]

#define QUALIFIED_MUM_ID    @"mombaby@163.com"
#define QUALIFIED_MUM_PWD   @"19881014hk"

#define KBGUID              [STDUIO_DIC objectForKey:@"kbguid"]

#define LEFT_CONTERLLER_WIDTH   256
#define RIGHT_CONTERLLER_WIDTH  250
#define YEAR_NUMBER             7
#define PICKER_HEIGHT   216


#define SHAREVIEW_HEIGHT        190.0f
#define IS_MENU_SPACE           (frame.size.width==320?88:86)
#define IS_MENU_START           (frame.size.width==320?48:16)
#define NAME_LABEL_FRAME        (MAIN_WINDOW_HEIGHT==480?340:430)

#define ALBUM_GUID          [NETWORK_PLIST objectForKey:@"AlbumGuid"]

//#define RECOMMEND_TEXT              @"推荐好友得精美水晶签字笔，被推荐好友可得价值人民币600元精修照片5张。"

#pragma mark - HeaderFileName

#import "UIDefine.h"
#import "UIColor+Hex.h"

#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AVFoundation/AVFoundation.h>

// WIZ_SDK
#import"WizGlobals.h"
#import "WizObject.h"
#import "WizDBManager.h"
#import"WizAccountManager.h"
#import"CommonString.h"
#import"WizLogger.h"
#import"WizSettings.h"

#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "TMQuiltView.h"
#import "TMQuiltViewController.h"
#import "TMPhotoQuiltViewCell.h"
#import "PNColor.h"
#import "AMRatingControl.h"
#import "Animations.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "CBTextView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ZipArchive.h"
#import "Reachability.h"
#import "TFHpple.h"
#import "PagedFlowView.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"

#import "NetworkClass.h"

#import "WXC_AppDelegate.h"
#import "WXC_MainViewController.h"
#import "WXC_MenuViewController.h"
#import "WXC_PhotoViewController.h"
#import "WXC_ActivityViewController.h"
#import "WXC_RecommendViewController.h"
#import "WXC_ShareViewController.h"
#import "WXC_GradeViewController.h"
#import "WXC_StudioViewController.h"
#import "WXC_ProductionDetailViewController.h"
#import "WXC_BoundViewController.h"
#import "WXC_PoweredByViewController.h"
#import "WXC_AutoPlayViewController.h"
#import "WXC_AboutViewController.h"
#import "WXC_GrowingViewController.h"

#import "WXC_MenuButton.h"
#import "WXC_ProductionTableViewCell.h"
#import "WXC_PlatformTableViewCell.h"
#import "WXC_CoverImageView.h"
#import "WXC_ShareView.h"









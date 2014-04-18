//
//  WXC_ProductionDetailViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_ProductionDetailViewController.h"

@interface WXC_ProductionDetailViewController ()< WizSyncDownloadDelegate>
{
    UIWebView *_productionWebView;
    WXC_ShareView *_shareView;
}

@end

@implementation WXC_ProductionDetailViewController

- (void)dealloc
{
    [[WizNotificationCenter shareCenter]removeObserver:self];
}

- (id)initWithGuid:(NSString *)guid AndProductionTitle:(NSString *)productionTitle
{
    self = [super init];
    if (self) {
        NSLog(@"guid - %@ productionTitle - %@",guid,productionTitle);
        _guid = [NSString stringWithString:guid];
        _productionTitle = [NSString stringWithString:productionTitle];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(75, 0, 170, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = _productionTitle;
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [navView addSubview:navLabel];
    
    // tag - 700
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回点击"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 700;
    [navView addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(256, 0, 64, 44);
    [shareBtn setImage:[UIImage imageNamed:@"主页分享"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享点击"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 701;
    [navView addSubview:shareBtn];
    
    _productionWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT)];
    _productionWebView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1];
    [self.view addSubview:_productionWebView];
    
    [SVProgressHUD showWithStatus:@""];
    
    NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:_guid];
    if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
    {
        [[WizNotificationCenter shareCenter] addDownloadDelegate:self];
        [[WizSyncCenter shareCenter] downloadDocument:_guid kbguid:KBGUID accountUserId:USER_ID];
    }
    else
    {
        [self didDownloadEnd:_guid];
    }
    
    _shareView = [[WXC_ShareView alloc] initWithFrame:CGRectMake(0, MAIN_WINDOW_HEIGHT, 320, SHAREVIEW_HEIGHT)];
    _shareView.shareClickType = ArticleShare;
    [self.view addSubview:_shareView];
    
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:STATISTICS_URL,KBGUID,@"-1",@"1"]];
}

// 网页截图
//- (UIImage *)screenShot:(UIWebView *)webView
//{
//    UIGraphicsBeginImageContext(((UIScrollView *)[[[web.subviews objectAtIndex:0] subviews] objectAtIndex:0]).frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    [((UIScrollView *)[[[web.subviews objectAtIndex:0] subviews] objectAtIndex:0]).layer renderInContext:context];
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

- (void)navBarBtnClick:(UIButton *)sender
{
    if (sender.tag == 700)
    {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender.tag == 701)
    {
        NSLog(@"Share");
        [_shareView moveViewAndShow];
    }
    else
        NSLog(@"Error");
}

- (void)didDownloadEnd:(NSString *)guid
{
    NSLog(@"guid -- %@",guid);
    [SVProgressHUD dismiss];
    if ([guid isEqualToString:_guid]) {
        NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:guid];
        if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
        {
            [[WizFileManager shareManager] prepareReadingEnviroment:guid accountUserId:USER_ID];
        }
        
        NSURL *articleFileURL = [NSURL fileURLWithPath:filePathString];
        NSURLRequest *articleFileURLRequest = [NSURLRequest requestWithURL:articleFileURL];
        [_productionWebView loadRequest:articleFileURLRequest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

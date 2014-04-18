//
//  WXC_AboutViewController.m
//  WeiXiangce
//
//  Created by mac on 14-1-13.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "WXC_AboutViewController.h"

@interface WXC_AboutViewController ()< WizSyncDownloadDelegate>
{
    UIWebView *_aboutWebView;
}

@end

@implementation WXC_AboutViewController

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
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, MAIN_WINDOW_HEIGHT-STATUS_BAR_HEIGHT);
    backView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1];
    [self.view addSubview:backView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = @"关于影楼";
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [self.view addSubview:navLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回点击"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navLabel addSubview:backBtn];
    
    _aboutWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT-STATUS_BAR_AND_NAV_BAR_HEIGHT)];
    [backView addSubview:_aboutWebView];
    
    NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:STUDIO_ABOUT];
    if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
    {
        [[WizNotificationCenter shareCenter] addDownloadDelegate:self];
        [[WizSyncCenter shareCenter] downloadDocument:STUDIO_ABOUT kbguid:KBGUID accountUserId:USER_ID];
    }
    else
    {
        [self didDownloadEnd:STUDIO_ABOUT];
    }
    
}

- (void)didDownloadEnd:(NSString *)guid
{
    NSLog(@"guid -- %@",guid);
    if ([guid isEqualToString:STUDIO_ABOUT]) {
        NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:guid];
        if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
        {
            [[WizFileManager shareManager] prepareReadingEnviroment:guid accountUserId:USER_ID];
        }
        
        NSURL *articleFileURL = [NSURL fileURLWithPath:filePathString];
        NSURLRequest *articleFileURLRequest = [NSURLRequest requestWithURL:articleFileURL];
        [_aboutWebView loadRequest:articleFileURLRequest];
    }
}

- (void)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

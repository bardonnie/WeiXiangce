//
//  WXC_BoundViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_BoundViewController.h"

@interface WXC_BoundViewController ()

@end

@implementation WXC_BoundViewController

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
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, MAIN_WINDOW_HEIGHT-STATUS_BAR_HEIGHT);
    backView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1];
    [self.view addSubview:backView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = @"关于萌猫";
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
    
}

- (void)backBtnClick:(UIButton *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

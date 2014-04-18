//
//  WXC_PoweredByViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_PoweredByViewController.h"

@interface WXC_PoweredByViewController ()

@end

@implementation WXC_PoweredByViewController

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
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, MAIN_WINDOW_HEIGHT-STATUS_BAR_HEIGHT);
    backView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1];
    [self.view addSubview:backView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = @"Powered By 萌猫";
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
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(20, NAV_BAR_HEIGHT+20, 280, 100);
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.text = @"盘客天下致力于为企业和个人打造专属的ios与Android版手机、平板应用，并 提供应用发布、市场推广和日常运营等整套解决方案。无需编程能力和架设服 务器,就可以制作运营您的专属APP。";
    detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:detailLabel];
    
    UILabel *advLabel = [[UILabel alloc]  init];
    advLabel.frame = CGRectMake(20, NAV_BAR_HEIGHT+120, 280, NAV_BAR_HEIGHT);
    advLabel.backgroundColor = [UIColor clearColor];
    advLabel.text = @"我们的优势";
    advLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:advLabel];
    
    NSArray *advNamesArray = [[NSArray alloc] initWithObjects:@"快速搭建：5天给您一个惊喜",@"模版丰富：20余种界面风格",@"操作流畅：用户体验友好",@"运行稳定：各配置机型崩溃率低",@"安全可靠：采用阿里云存储服务", nil];
    for (int i = 0; i<advNamesArray.count; i++) {
        UILabel *advInfoLabel = [[UILabel alloc] init];
        advInfoLabel.frame = CGRectMake(40, NAV_BAR_HEIGHT+160+i*18, 280, 18);
        advInfoLabel.backgroundColor = [UIColor clearColor];
        advInfoLabel.text = [advNamesArray objectAtIndex:i];
        advInfoLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:advInfoLabel];
    }
    
    UILabel *pankerLabel = [[UILabel alloc] init];
    pankerLabel.frame = CGRectMake(0, NAV_BAR_HEIGHT+300, 320, 18);
    pankerLabel.backgroundColor = [UIColor clearColor];
    pankerLabel.text = @"详情请访问盘客官网";
    pankerLabel.textAlignment = NSTextAlignmentCenter;
    pankerLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:pankerLabel];
    
    UITextView *pankerTextView = [[UITextView alloc] init];
    pankerTextView.frame = CGRectMake(0, NAV_BAR_HEIGHT+318, 320, 40);
    pankerTextView.backgroundColor = [UIColor clearColor];
    pankerTextView.editable = NO;
    pankerTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    pankerTextView.text = @"www.panker.cn";
    pankerTextView.textAlignment = NSTextAlignmentCenter;
    pankerTextView.font = [UIFont systemFontOfSize:16];
    pankerTextView.textColor = [UIColor_Hex colorWithHex:0xbd8b05];
    [backView addSubview:pankerTextView];
    
}

- (void)backBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WXC_GradeViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_GradeViewController.h"

@interface WXC_GradeViewController ()< UIScrollViewDelegate, NetworkClassDelegate>
{
    UIScrollView *_gradeScrollView;
    CBTextView *_askTextView;
    NSString *_cameraman;
    NSString *_dresser;
    NSString *_result;
    NSString *_service;
    UITextField *_phoneNumber;
}

@end

@implementation WXC_GradeViewController

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
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = @"摄影评分";
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
    
    _gradeScrollView = [[UIScrollView alloc] init];
    _gradeScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT);
    _gradeScrollView.contentSize = CGSizeMake(320, NAV_VIEW_HEIGHT);
    _gradeScrollView.backgroundColor = [UIColor whiteColor];
    _gradeScrollView.delegate = self;
    [self.view addSubview:_gradeScrollView];
    
    // tag - 800
    NSArray *typeNamesArray = [[NSArray alloc] initWithObjects:@"摄影师",@"化妆师",@"拍摄效果",@"服务态度", nil];
    for (int i = 0; i<4; i++)
    {
        UIView *typeView = [[UIView alloc] init];
        typeView.frame = CGRectMake(0, 44*i, 320, 43);
        typeView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1 alpha:1];
        [_gradeScrollView addSubview:typeView];
        
        UILabel *typeNameLabel = [[UILabel alloc] init];
        typeNameLabel.frame = CGRectMake(0, 0, 114, 43);
        typeNameLabel.text = [typeNamesArray objectAtIndex:i];
        typeNameLabel.textAlignment = NSTextAlignmentCenter;
        typeNameLabel.font = [UIFont systemFontOfSize:18];
        typeNameLabel.backgroundColor = [UIColor_Hex colorWithHex:0xecc55c alpha:1];
        [typeView addSubview:typeNameLabel];
        
        AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(144, 4)
                                                                               emptyColor:[UIColor whiteColor]
                                                                               solidColor:[UIColor_Hex colorWithHex:0xecc55c] andMaxRating:5];
        coloredRatingControl.tag = i+800;
        [coloredRatingControl addTarget:self action:@selector(coloredRatingControlTouched:) forControlEvents:UIControlEventEditingDidEnd];
        [typeView addSubview:coloredRatingControl];
    }
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(0, 172, 320, 38);
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"各项最低为1颗星，满意请给5颗星";
    tipLabel.textColor = [UIColor_Hex colorWithHex:0xbd8b05];
    [_gradeScrollView addSubview:tipLabel];
    
//    cbtextview
    _askTextView = [[CBTextView alloc] init];
    _askTextView.frame = CGRectMake(20, 204, 280, 110);
    _askTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _askTextView.layer.borderWidth = 1.0;
    _askTextView.layer.cornerRadius = 4.0;
    _askTextView.backgroundColor = [UIColor whiteColor];
    _askTextView.textView.font = [UIFont systemFontOfSize:16];
    _askTextView.placeHolder = @"把你对影楼的感受告诉我们吧~";
    [_gradeScrollView addSubview:_askTextView];
    
    _phoneNumber = [[UITextField alloc] init];
    _phoneNumber.frame = CGRectMake(20, 320, 280, 27);
    _phoneNumber.backgroundColor = [UIColor clearColor];
    _phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumber.placeholder = @"请输入您的电话号码~";
    [_phoneNumber setBackground:[UIImage imageNamed:@"联系电话"]];
    [_gradeScrollView addSubview:_phoneNumber];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(73, 355, 174, 39);
    [submitBtn setImage:[UIImage imageNamed:@"推荐好友提交"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_gradeScrollView addSubview:submitBtn];
    
    // 键盘通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [NetworkClass shareNetworkClass].delegate = self;
}

- (void)submitBtnClick:(UIButton *)sender
{
    NSLog(@"submitBtnIsClick _cameraman - %@",_cameraman);
    
    if ([_askTextView.textView.text isEqual:@""]) {
        
    }
    else if (!_cameraman || [_cameraman isEqual:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:@"摄影师评分最低一颗星！"];
    }
    else if (!_dresser || [_dresser isEqual:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:@"化妆师评分最低一颗星！"];
    }
    else if (!_result || [_result isEqual:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:@"拍摄效果评分最低一颗星！"];
    }
    else if (!_service || [_service isEqual:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:@"服务态度评分最低一颗星！"];
    }
    else if ([_phoneNumber.text isEqual:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话！"];
    }
    else
    {
        [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:ADDGRADE_URL,KBGUID,_askTextView.textView.text,_cameraman,_dresser,_result,_service,_phoneNumber.text,USER_NAME]];
        NSLog(@"url - %@",[NSString stringWithFormat:ADDGRADE_URL,KBGUID,_askTextView.textView.text,_cameraman,_dresser,_result,_service,_phoneNumber.text,USER_NAME]);
        [SVProgressHUD showWithStatus:@""];
    }
}

- (void)httpRequestMessage:(NSString *)message
{
    NSLog(@"message - %@",message);
    if ([message isEqual:@"True"]) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)coloredRatingControlTouched:(AMRatingControl *)sender
{
    NSLog(@"AMRatingControl - %d - %d", sender.tag,[sender rating]);
    [_askTextView.textView resignFirstResponder];
    [_phoneNumber resignFirstResponder];
    switch (sender.tag) {
        case 800:
            _cameraman = [NSString stringWithFormat:@"%d",[sender rating]];
            break;
        case 801:
            _dresser = [NSString stringWithFormat:@"%d",[sender rating]];
            break;
        case 802:
            _result = [NSString stringWithFormat:@"%d",[sender rating]];
            break;
        case 803:
            _service = [NSString stringWithFormat:@"%d",[sender rating]];
            break;
        default:
            break;
    }
}

- (void)keyBoardWillShow:(NSNotificationCenter *)sender
{
    _gradeScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, MAIN_WINDOW_HEIGHT-KEYBOARD_HEIGHT-IOS7_OR_LATER_Y);
    [UIView animateWithDuration:.5 animations:^{
        if (MAIN_WINDOW_HEIGHT == 480) {
            _gradeScrollView.contentOffset = CGPointMake(0, 200);
        }
        else
        {
            _gradeScrollView.contentOffset = CGPointMake(0, 150);
        }
    }];
}

- (void)keyBoardWillHidden:(NSNotificationCenter *)sender
{
    [UIView animateWithDuration:.5 animations:^{
        _gradeScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT);
    }];
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

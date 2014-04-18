//
//  WXC_RecommendViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_RecommendViewController.h"

@interface WXC_RecommendViewController ()< ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NetworkClassDelegate, WizSyncDownloadDelegate>
{
    UITextField *_optionTextField;
    UIView *_optionBackView;
    UIScrollView *_recommendScrollView;
    NSArray *_typeNamesArray;
    UILabel *_numberLabel;
    NSString *_name;
    NSString *_phoneNumber;
    NSString *_type;
    UILabel *_explainLabel;
}

@end

@implementation WXC_RecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:REALBUM_URL,KBGUID]];
    [NetworkClass shareNetworkClass].delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, MAIN_WINDOW_HEIGHT-STATUS_BAR_HEIGHT);
    backView.backgroundColor = [UIColor_Hex colorWithHex:0xecc55c];
    [self.view addSubview:backView];

    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = @"推荐好友";
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [self.view addSubview:navLabel];
    
    // tag - 900
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回点击"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 900;
    [navLabel addSubview:backBtn];
    
    UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBookBtn.frame = CGRectMake(256, 0, 64, 44);
    [addressBookBtn setImage:[UIImage imageNamed:@"手机通讯录"] forState:UIControlStateNormal];
    [addressBookBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addressBookBtn.tag = 901;
    [navLabel addSubview:addressBookBtn];
    
    _recommendScrollView = [[UIScrollView alloc] init];
    _recommendScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT);
    _recommendScrollView.contentSize = CGSizeMake(320, NAV_VIEW_HEIGHT);
    _recommendScrollView.backgroundColor = [UIColor_Hex colorWithHex:0xecc55c];
    [self.view addSubview:_recommendScrollView];
    
    UIImageView *explainImageView = [[UIImageView alloc] init];
    explainImageView.frame = CGRectMake(10, 20, 300, 90);
    [explainImageView setImage:[UIImage imageNamed:@"推荐好友文字框"]];
    explainImageView.userInteractionEnabled = YES;
    [_recommendScrollView addSubview:explainImageView];
    
    _explainLabel = [[UILabel alloc] init];
    _explainLabel.frame = CGRectMake(20, 10, 260, 58);
    _explainLabel.backgroundColor = [UIColor clearColor];
    _explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _explainLabel.numberOfLines = 0;
    _explainLabel.font = [UIFont systemFontOfSize:14];
    [explainImageView addSubview:_explainLabel];
    
    [self parserRecommendText];
    
    // 推荐人数显示
    UIView *numberBackView = [[UIView alloc] init];
    numberBackView.frame = CGRectMake(0, 104, 320, 90);
    numberBackView.backgroundColor = [UIColor clearColor];
    [_recommendScrollView addSubview:numberBackView];
    
    UIImageView *numberImageView = [[UIImageView alloc] init];
    numberImageView.frame = CGRectMake(114, 0, 92, 92);
    [numberImageView setImage:[UIImage imageNamed:@"推荐圆圈"]];
    [numberBackView addSubview:numberImageView];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.frame = CGRectMake(0, 30, 92, 32);
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:32];
    [numberImageView addSubview:_numberLabel];
    
    NSString *leftPath = [[NSBundle mainBundle] pathForResource:@"Left" ofType:@"html"];
    NSURL *leftUrl = [NSURL fileURLWithPath:leftPath];
    NSURLRequest *leftRequest = [NSURLRequest requestWithURL:leftUrl];
    
    NSString *rightPath = [[NSBundle mainBundle] pathForResource:@"Right" ofType:@"html"];
    NSURL *rightUrl = [NSURL fileURLWithPath:rightPath];
    NSURLRequest *rightRequest = [NSURLRequest requestWithURL:rightUrl];
    
    UIWebView *leftWebView = [[UIWebView alloc] init];
    leftWebView.frame = CGRectMake(0, 5, 114, 80);
    leftWebView.backgroundColor = [UIColor clearColor];
    [leftWebView loadRequest:leftRequest];
    [numberBackView addSubview:leftWebView];
    
    UIWebView *rightWebView = [[UIWebView alloc] init];
    rightWebView.frame = CGRectMake(206, 5, 114, 80);
    rightWebView.backgroundColor = [UIColor clearColor];
    [rightWebView loadRequest:rightRequest];
    [numberBackView addSubview:rightWebView];
    
    // 好友选项
    // tag - 1000
    _optionBackView = [[UIView alloc] init];
    _optionBackView.frame = CGRectMake(0, 210, 320, 105);
    _optionBackView.backgroundColor = [UIColor_Hex colorWithHex:0xecc55c];
    [_recommendScrollView addSubview:_optionBackView];
    
    NSArray *optionNamesArray = [[NSArray alloc] initWithObjects:@"称呼：",@"电话：",@"类型：", nil];
    NSArray *optionTextFieldImagesArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"推荐好友称呼框"],[UIImage imageNamed:@"推荐好友电话框"],[UIImage imageNamed:@"推荐好友类型框"], nil];
    for (int i = 0; i<optionNamesArray.count; i++) {
        UILabel *optionNameLabel = [[UILabel alloc] init];
        optionNameLabel.frame = CGRectMake(0, i*35, 120, 35);
        optionNameLabel.backgroundColor = [UIColor clearColor];
        optionNameLabel.text = [optionNamesArray objectAtIndex:i];
        optionNameLabel.textAlignment = NSTextAlignmentRight;
        optionNameLabel.textColor = [UIColor whiteColor];
        optionNameLabel.font = [UIFont systemFontOfSize:18];
        [_optionBackView addSubview:optionNameLabel];
        
        _optionTextField = [[UITextField alloc] init];
        _optionTextField.tag = 1000+i;
        _optionTextField.delegate = self;
        if (i == 0)
        {
            _optionTextField.frame = CGRectMake(120, 4+i*35, 70, 27);
            UILabel *manOrWomenLabel = [[UILabel alloc] init];
            manOrWomenLabel.frame = CGRectMake(204, 0, 100, 35);
            manOrWomenLabel.backgroundColor = [UIColor clearColor];
            manOrWomenLabel.text = @"女士/先生";
            manOrWomenLabel.textColor = [UIColor whiteColor];
            manOrWomenLabel.font = [UIFont systemFontOfSize:18];
            [_optionBackView addSubview:manOrWomenLabel];
        }
        else
        {
            _optionTextField.frame = CGRectMake(120, 4+i*35, 120, 27);
        }
        if (i == 1)
            _optionTextField.keyboardType = UIKeyboardTypePhonePad;
        if (i == 2)
        {
            UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"推荐好友下拉箭头"]];
            rightImageView.frame = CGRectMake(92, 6, 14, 14);
            [_optionTextField addSubview:rightImageView];
        }
        _optionTextField.borderStyle = UITextBorderStyleRoundedRect;
        [_optionTextField setBackground:[optionTextFieldImagesArray objectAtIndex:i]];
        _optionTextField.backgroundColor = [UIColor clearColor];
        _optionTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _optionTextField.textAlignment = NSTextAlignmentCenter;
        _optionTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        _optionTextField.layer.borderWidth = 2;
        _optionTextField.layer.cornerRadius = 2;
        [_optionBackView addSubview:_optionTextField];
    }
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 320, 320, 39);
    [submitBtn setImage:[UIImage imageNamed:@"推荐好友提交"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_recommendScrollView addSubview:submitBtn];
    
    // 键盘通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _name = [[NSString alloc] init];
    _phoneNumber = [[NSString alloc] init];
    _type = [[NSString alloc] init];
}

- (void)navBarBtnClick:(UIButton *)sender
{
    if (sender.tag == 900)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender.tag == 901)
    {
        ABPeoplePickerNavigationController *peoleVC = [[ABPeoplePickerNavigationController alloc] init];
        peoleVC.peoplePickerDelegate = self;
        [self presentViewController:peoleVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"person - %@",person);
    NSString *name = [NSString stringWithFormat:@"%@",ABRecordCopyCompositeName(person)];
    NSLog(@"=======>%@",name);
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    NSString *aPhone;
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        aPhone = [NSString stringWithFormat:@"%@",ABMultiValueCopyValueAtIndex(phoneMulti, i)];
        [phones addObject:aPhone];
    }
    NSLog(@"=======>%@",aPhone);
    
    _phoneNumber = aPhone;
    _name = name;
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        for (UITextField *textField in [_optionBackView subviews]) {
            if (textField.tag == 1000) {
                textField.text = _name;
            }
            if (textField.tag == 1001) {
                textField.text = _phoneNumber;
            }
        }
    }];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark - optionTextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1002) {
        UIToolbar *typeToolbar = [[UIToolbar alloc] init];
        typeToolbar.frame = CGRectMake(0, IOS7_MAINVIEW_HEIGHT, 320, NAV_BAR_HEIGHT);
        UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarBtnClick:)];
        UIBarButtonItem *itemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray *typeToolbarItemsArray = [[NSArray alloc] initWithObjects:itemFlexibleSpace,doneBarBtn, nil];
        [typeToolbar setItems:typeToolbarItemsArray];
        
        _typeNamesArray = [[NSArray alloc] initWithObjects:@"请选择",@"婚纱摄影",@"亲子摄影",@"个人写真", nil];
        UIPickerView *typePickerView = [[UIPickerView alloc] init];
        typePickerView.frame = CGRectMake(0, IOS7_MAINVIEW_HEIGHT-KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT-NAV_BAR_HEIGHT);
        typePickerView.backgroundColor = [UIColor whiteColor];
        typePickerView.delegate = self;
        typePickerView.dataSource = self;
        typePickerView.showsSelectionIndicator = YES;
        textField.inputView = typePickerView;
        textField.inputAccessoryView = typeToolbar;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"string - %@",textField.text);
    if (textField.tag == 1000) {
        _name = textField.text;
    }
    else if (textField.tag == 1001)
    {
        _phoneNumber = textField.text;
    }
    else if (textField.tag == 1002)
    {
       
    }
}

#pragma mark - typePickerViewDelegateDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _typeNamesArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"-row- %@",[_typeNamesArray objectAtIndex:row]);
    if (_optionTextField.tag == 1002) {
        _optionTextField.text = [_typeNamesArray objectAtIndex:row];
        _type = [NSString stringWithFormat:@"%d",row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_typeNamesArray objectAtIndex:row];
}

#pragma mark - NetworkClassDelegate
- (void)httpRequestMessage:(NSString *)message
{
    NSLog(@"message - %@",message);
    if ([message isEqualToString:@"True"]) {
        [SVProgressHUD showSuccessWithStatus:nil];
        [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:REALBUM_URL,KBGUID]];
    }
    else if ([message isEqualToString:@""]) {
        
    }
    else{
        _numberLabel.text = message;
    }
}

- (void)parserRecommendText
{
    NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:STUDIO_RECOMM];
    if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
    {
        [[WizNotificationCenter shareCenter] addDownloadDelegate:self];
        [[WizSyncCenter shareCenter] downloadDocument:STUDIO_RECOMM kbguid:KBGUID accountUserId:USER_ID];
    }
    else
    {
        [self didDownloadEnd:STUDIO_RECOMM];
    }
}

- (void)didDownloadEnd:(NSString *)guid
{
    NSLog(@"guid -- %@",guid);
    if ([guid isEqualToString:STUDIO_RECOMM]) {
        NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:guid];
        if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
        {
            [[WizFileManager shareManager] prepareReadingEnviroment:guid accountUserId:USER_ID];
        }
                
        _explainLabel.text = [[NetworkClass shareNetworkClass] parserRecommendText:filePathString];
        NSLog(@"str - %@",_explainLabel.text);
    }
}

- (void)keyBoardWillShow:(NSNotificationCenter *)sender
{
    _recommendScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, MAIN_WINDOW_HEIGHT-KEYBOARD_HEIGHT-IOS7_OR_LATER_Y);
    [UIView animateWithDuration:.5 animations:^{

        if (MAIN_WINDOW_HEIGHT == 480) {
            _recommendScrollView.contentOffset = CGPointMake(0, 200);
        }
        else
        {
            _recommendScrollView.contentOffset = CGPointMake(0, 100);
        }
    }];
}

- (void)keyBoardWillHidden:(NSNotificationCenter *)sender
{
    [UIView animateWithDuration:.5 animations:^{
        _recommendScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, MAIN_WINDOW_HEIGHT-IOS7_OR_LATER_Y);
    }];
}

- (void)submitBtnClick
{
    NSLog(@"name - %@ number - %@ type - %@",_name,_phoneNumber,_type);
    [SVProgressHUD showErrorWithStatus:@"正在提交…"];
    if ([_name isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名！"];
    }
    else if ([_phoneNumber isEqual:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写电话！"];
    }
    else if ([_type isEqual:@""] || [_type isEqual:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:@"请选择用户类型！"];
    }
    else
    {
        [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:RECOMMEND_URL,_name,_phoneNumber,_type,KBGUID,USER_NAME]];
    }
    [_optionTextField resignFirstResponder];
}

- (void)doneBarBtnClick:(UIBarButtonItem *)sender
{
    [_optionTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

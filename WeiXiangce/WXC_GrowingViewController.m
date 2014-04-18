//
//  WXC_GrowingViewController.m
//  WeiXiangce
//
//  Created by mac on 14-3-28.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "WXC_GrowingViewController.h"

@interface WXC_GrowingViewController ()< PagedFlowViewDelegate, PagedFlowViewDataSource>

@end

@implementation WXC_GrowingViewController
{
    PagedFlowView *_pagedFlowView;
    NSMutableArray *_viewArray;
    UIDatePicker *_datePicker;
    UIView *_dateView;
    UIControl *_dateControl;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _viewArray = [[NSMutableArray alloc] init];
    for (int i = YEAR_NUMBER; i>=0; i--)
    {
        UIView *yearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_CONTERLLER_WIDTH, 75)];
        
        UIImageView *circlevView = [[UIImageView alloc] initWithFrame:CGRectMake(87.5, 2, 75, 75)];
        [circlevView setImage:[UIImage imageNamed:@"圆"]];
        circlevView.tag = 1;
        [yearView addSubview:circlevView];
        
        UIImageView *defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(91, 6, 67, 67)];
        [defaultImageView setImage:[UIImage imageNamed:@"无相册"]];
        defaultImageView.backgroundColor = [UIColor  clearColor];
        [yearView addSubview:defaultImageView];
        
        UIImageView *camerImageView = [[UIImageView alloc] init];
        [camerImageView setImage:[UIImage imageNamed:@"相机"]];
        [yearView addSubview:camerImageView];
        
        UILabel *studioNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 52, 64, 10)];
        studioNameLabel.text = STUDIO_NAME;
        studioNameLabel.font = [UIFont systemFontOfSize:10];
        studioNameLabel.textColor = [UIColor_Hex colorWithHex:0x57442e];
        [yearView addSubview:studioNameLabel];
        
        UIImageView *ageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_%d",i+1]]];
        ageView.tag = 2;
        if (i%2 == 1) {
            ageView.frame = CGRectMake(10, 27, 74, 23);
            camerImageView.frame = CGRectMake(12, 52, 12, 10);
            studioNameLabel.frame = CGRectMake(26, 52, 64, 10);
        }
        else
        {
            ageView.frame = CGRectMake(168, 27, 74, 23);
            camerImageView.frame = CGRectMake(176, 52, 12, 10);
            studioNameLabel.frame = CGRectMake(190, 52, 64, 10);
        }
        [yearView addSubview:ageView];
        
        [_viewArray addObject:yearView];
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_CONTERLLER_WIDTH, MAIN_WINDOW_HEIGHT)];
    [backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImageView];
    
    _pagedFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_CONTERLLER_WIDTH, MAIN_WINDOW_HEIGHT)];
    _pagedFlowView.dataSource = self;
    _pagedFlowView.delegate = self;
    
    _pagedFlowView.minimumPageAlpha = 0.4;
    _pagedFlowView.minimumPageScale = 0.7;
    _pagedFlowView.clipsToBounds = NO;
    _pagedFlowView.userInteractionEnabled = YES;
    _pagedFlowView.orientation = PagedFlowViewOrientationVertical;
    [self.view addSubview:_pagedFlowView];
    
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, MAIN_WINDOW_HEIGHT, 320, PICKER_HEIGHT+NAV_BAR_HEIGHT)];
    _dateView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *optionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_BAR_HEIGHT)];
    [optionImageView setImage:[UIImage imageNamed:@"上边的小条"]];
    optionImageView.userInteractionEnabled = YES;
    [_dateView addSubview:optionImageView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, NAV_BAR_HEIGHT);
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [optionImageView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(260, 0, 60, NAV_BAR_HEIGHT);
    [sureBtn setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [optionImageView addSubview:sureBtn];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//设置为英文显示
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, 320, PICKER_HEIGHT)];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_datePicker setMaximumDate:[NSDate date]];
    _datePicker.locale = locale;
    _datePicker.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"下边的底"]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_dateView addSubview:_datePicker];
    
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 6, 132, 308, 40)];
    [selectImageView setImage:[UIImage imageNamed:@"半透明条"]];
    [_dateView addSubview:selectImageView];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]/*如果不是第二次使用*/)
    {
        _pagedFlowView.timeLabel.text = @"2014-01-01";
    }
    else
    {
        _pagedFlowView.timeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"bith"];
    }
}

- (void)calendarBtnClick
{
    WXC_AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    _dateControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT)];
    _dateControl.backgroundColor = [UIColor blackColor];
    [_dateControl addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _dateControl.alpha = .5;
    [delegate.drawerController.view addSubview:_dateControl];
    
    [delegate.drawerController.view addSubview:_dateView];
    
    [Animations moveUp:_dateView andAnimationDuration:0.2 andWait:YES andLength:PICKER_HEIGHT+NAV_BAR_HEIGHT];
    [Animations moveDown:_dateView andAnimationDuration:0.2 andWait:YES andLength:5.0];
    [Animations moveUp:_dateView andAnimationDuration:0.1 andWait:YES andLength:5.0];

    NSLog(@"***");
}

- (void)cancelBtnClick
{
    [_dateControl removeFromSuperview];
    [Animations moveDown:_dateView andAnimationDuration:0.2 andWait:YES andLength:PICKER_HEIGHT+NAV_BAR_HEIGHT];
}

- (void)sureBtnClick
{
    [[NSUserDefaults standardUserDefaults] setValue:[self stringFromDate:_datePicker.date] forKeyPath:@"bith"];
    _pagedFlowView.timeLabel.text = [self stringFromDate:_datePicker.date];
    [self cancelBtnClick];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(RIGHT_CONTERLLER_WIDTH, 75);
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index
{
    NSLog(@"Scrolled to page # %d", index);
    for (int i = 0; i<_viewArray.count; i++)
    {
        if (i == index)
        {
            UIView *backView = [_viewArray objectAtIndex:i];
            for (UIImageView *view in [backView subviews])
            {
                if (view.tag == 1) {
                    [view setImage:[UIImage imageNamed:@"圆-棕"]];
                }
                if (view.tag == 2) {
                    [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_%d_z",_viewArray.count-i]]];
                }
            }
        }
        else
        {
            UIView *backView = [_viewArray objectAtIndex:i];
            for (UIImageView *view in [backView subviews])
            {
                if (view.tag == 1) {
                    [view setImage:[UIImage imageNamed:@"圆"]];
                }if (view.tag == 2) {
                    [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_%d",_viewArray.count-i]]];
                }
            }
        }
    }
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index
{
    NSLog(@"Tapped on page # %d", index);
    if (index == 1000) {
        [self calendarBtnClick];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return [_viewArray count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    return [_viewArray objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

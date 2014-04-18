//
//  WXC_PhotoViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-17.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_PhotoViewController.h"

@interface WXC_PhotoViewController ()< UIScrollViewDelegate, WXC_AutoPlayViewControllerDelegate>
{
    NSMutableArray *_photoImageViews;
    UIScrollView *_photoScrollView;
    WXC_ShareView *_shareView;
    UIView *_toolView;
    
    int _scrollViewStartX;
    int _scrollViewEndX;
}

@end

@implementation WXC_PhotoViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImages:(NSArray *)photos Index:(int)index
{
    self = [super init];
    if (self) {
        NSLog(@"image - %@ index - %d",photos,index);
        _photosArray = [[NSMutableArray alloc] initWithArray:photos];
        _index = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    _photoScrollView = [[UIScrollView alloc] init];
    _photoScrollView.frame = CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT);
    _photoScrollView.backgroundColor = [UIColor blackColor];
    _photoScrollView.contentSize = CGSizeMake(320*_photosArray.count, MAIN_WINDOW_HEIGHT);
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.tag = 2000;
    [self.view addSubview:_photoScrollView];
    
    _photoImageViews = [[NSMutableArray alloc] init];
    
    for (UIImage *image in _photosArray)
    {
        
    }
    
    // tag - 100
    int i = 0;
    for (UIImage *photo in _photosArray)
    {
        UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageIsTouch:)];
        tapRecognizer1.numberOfTapsRequired = 1;
        tapRecognizer1.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageZoom:)];
        tapRecognizer2.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapRecognizer2];
        
        UIScrollView *photoImageScrollView = [[UIScrollView alloc] init];
        photoImageScrollView.frame = CGRectMake(i*320, 0, 320, MAIN_WINDOW_HEIGHT);
        photoImageScrollView.userInteractionEnabled = YES;
        photoImageScrollView.delegate = self;
        photoImageScrollView.tag = 1300+i;
        photoImageScrollView.maximumZoomScale = 3.0;
        photoImageScrollView.minimumZoomScale = 1.0;
        
        UIImageView *photoImage = [[UIImageView alloc] init];
        photoImage.frame = CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT);
        photoImage.image = photo;
        photoImage.contentMode = UIViewContentModeScaleAspectFit;
        photoImage.userInteractionEnabled = YES;
        photoImage.tag = i+100;
        
        [photoImageScrollView addSubview:photoImage];
        [photoImageScrollView addGestureRecognizer:tapRecognizer1];
        [photoImageScrollView addGestureRecognizer:tapRecognizer2];
        photoImageScrollView.contentSize = CGSizeMake(photoImage.frame.size.width, photoImage.frame.size.height);
        [_photoScrollView addSubview:photoImageScrollView];
        
        [tapRecognizer1 requireGestureRecognizerToFail:tapRecognizer2];
        
        [_photoImageViews addObject:photoImage];
        i++;
    }
    _photoScrollView.contentOffset = CGPointMake(_index*320, 0);
    
    _toolView = [[UIView alloc] init];
    _toolView.frame = CGRectMake(0, MAIN_WINDOW_HEIGHT-66, 320, 66);
    _toolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photonavbackview"]];
    _toolView.userInteractionEnabled = YES;
    [self.view addSubview:_toolView];
    
    // tag - 1100
    NSArray *functionImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"内容页分享"],[UIImage imageNamed:@"内容页分享点击"],[UIImage imageNamed:@"内容页播放"],[UIImage imageNamed:@"内容页播放点击"], nil];
    for (int i = 0; i<functionImages.count/2; i++) {
        UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        functionBtn.frame = CGRectMake(160*i, 0, 160, 66);
        [functionBtn setImage:[functionImages objectAtIndex:i*2] forState:UIControlStateNormal];
        [functionBtn setImage:[functionImages objectAtIndex:i*2+1] forState:UIControlStateHighlighted];
        functionBtn.tag = 1100+i;
        [functionBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:functionBtn];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showToolView) userInfo:nil repeats:YES];
    _shareView = [[WXC_ShareView alloc] initWithFrame:CGRectMake(0, MAIN_WINDOW_HEIGHT, MAIN_WINDOW_WIDTH, SHAREVIEW_HEIGHT)];
    _shareView.shareClickType = PhotoShare;
    [self.view addSubview:_shareView];
    
    _scrollViewEndX = 0;
    _scrollViewStartX = 0;
}

- (void)imageIsTouch:(UITapGestureRecognizer *)sender
{
    NSLog(@"%d",[sender view].tag);
    [self dismissViewControllerAnimated:YES completion:^{
        [_delegate selectImageIndex:[sender view].tag-100];
    }];
}

- (void)imageZoom:(UITapGestureRecognizer *)sender
{
    NSLog(@"%d",[sender view].tag);
    UIScrollView *scrollView = (UIScrollView *)[sender view];
    if (scrollView.zoomScale == 1) {
        [UIView animateWithDuration:.5 animations:^{
            scrollView.zoomScale = 2;
            [self.view reloadInputViews];
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            scrollView.zoomScale = 1;
            [self.view reloadInputViews];
        }];
    }
}

- (void)functionBtnClick:(UIButton *)sender
{
    NSLog(@"sender - %d",sender.tag);
    if (sender.tag == 1101)
    {
        WXC_AutoPlayViewController *autoPlayViewController = [[WXC_AutoPlayViewController alloc] initWithImages:_photosArray AndStartIndex:_index];
        autoPlayViewController.delegate = self;
        autoPlayViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve  ;
        [self presentViewController:autoPlayViewController animated:YES completion:^{
            
        }];
    }
    else
    {
        _shareView.shareImage = [_photosArray objectAtIndex:_index];
        [_shareView moveViewAndShow];
    }
}

#pragma mark - PhotoScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _index = scrollView.contentOffset.x/320;
    NSLog(@"-- %d",_index);
    if (scrollView.tag == 2000) {
        _scrollViewStartX = scrollView.contentOffset.x;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag >= 1300) {
        return [[scrollView subviews] objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 2000) {
        _scrollViewEndX = scrollView.contentOffset.x;
//        NSLog(@"*- %f",scrollView.contentOffset.y);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"#- %f",scrollView.contentOffset.y);

    if (scrollView.tag == 2000) {
        _scrollViewStartX = scrollView.contentOffset.x;
        NSLog(@"#- %f",scrollView.contentOffset.y);
    }
}

- (void)showToolView
{
    if (_scrollViewStartX - _scrollViewEndX == 0) {
        [UIView animateWithDuration:1 animations:^{
            _toolView.frame = CGRectMake(0, MAIN_WINDOW_HEIGHT-66, MAIN_WINDOW_WIDTH, 66);
        }];
    }
    else
    {
        [UIView animateWithDuration:.5 animations:^{
            _toolView.frame = CGRectMake(0, MAIN_WINDOW_HEIGHT, MAIN_WINDOW_WIDTH, 66);
        }];
    }
}


- (void)dismissControllerWithIndex:(int)index
{
    NSLog(@"dis Index - %d",index);
    _photoScrollView.contentOffset = CGPointMake(320*index, 0);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WXC_AutoPlayViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-24.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_AutoPlayViewController.h"

@interface WXC_AutoPlayViewController ()
{
    NSArray *_imagesArray;
    int _index;
    int _type;
    UIControl *_disControl;
    NSTimer *_timer;
    
    AVAudioPlayer *_backgroundPlayer;
}

@end

@implementation WXC_AutoPlayViewController

@synthesize delegate = _delegate;

- (id)initWithImages:(NSArray *)images AndStartIndex:(int)index
{
    self = [super init];
    if (self) {
        
        _disControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT)];
        _disControl.backgroundColor = [UIColor blackColor];
        [_disControl addTarget:self action:@selector(disControlIsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_disControl];
        
        _imagesArray = [[NSArray alloc] initWithArray:[self setImageViews:images]];
        NSLog(@"%d",_imagesArray.count  );
        NSLog(@"--- %d",index);
        _index = index;
        [_disControl addSubview:[_imagesArray objectAtIndex:index]];
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(play) userInfo:nil repeats:YES];
        _type = arc4random()%2;
        
        self.view.backgroundColor = [UIColor blackColor];
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];

    _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_backgroundPlayer setVolume:5];
    _backgroundPlayer.numberOfLoops = -1;
    [_backgroundPlayer play];
    
}

- (NSMutableArray *)setImageViews:(NSArray *)images
{
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    for (UIImage *image in images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [imageViews addObject:imageView];
    }
    return imageViews;
}

- (void)play
{
        [UIView animateWithDuration:2 animations:^{
            if (_type == 0) {
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_disControl cache:YES];
            }
            else
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_disControl cache:YES];
            }
            if (_index < _imagesArray.count-1) {
                [_disControl addSubview:[_imagesArray objectAtIndex:_index+1]];
            }
            else
            {
                [self disControlIsClick:nil];
            }
        }completion:^(BOOL finished)
         {
             if (_index < _imagesArray.count-1) {
                 [[_imagesArray objectAtIndex:_index+1] removeFromSuperview];
             }
             else
             {
                 [self disControlIsClick:nil];
             }
         }];
        _index++;
        NSLog(@"-- %d",_index);
}

- (void)disControlIsClick:(UIControl *)sender
{
    NSLog(@"platerTime - %f",_backgroundPlayer.currentTime);
    [_delegate dismissControllerWithIndex:_index];
    [self dismissViewControllerAnimated:YES completion:^{
        [_timer invalidate];
        [_backgroundPlayer pause];
    }];
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

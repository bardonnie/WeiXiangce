//
//  WXC_MainViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_MainViewController.h"

@interface WXC_MainViewController ()< TMQuiltViewDataSource, TMQuiltViewDelegate, WXC_PhotoViewControllerDelegate, ZipArchiveDelegate, NetworkClassDelegate>
{
    NSArray *_imageArray;
    TMQuiltView *_qtmquitView;
    int _numberOfLine;
    BOOL _isSwitchoverBtnClick;
    UIView *_navView;
    int _scrollViewStartY;
    int _scrollViewEndY;
}

@end

@implementation WXC_MainViewController

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
    // 设置初始状态
    [self setStatus];
    
    _imageArray = [[NSArray alloc] init];
    
    _qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT)];
	_qtmquitView.delegate = self;
	_qtmquitView.dataSource = self;
	[self.view addSubview:_qtmquitView];
    
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    _navView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homenavbackview"]];
    _navView.backgroundColor = [UIColor clearColor];
    _navView.userInteractionEnabled = YES;
    [self.view addSubview:_navView];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 64, 44);
    [menuBtn setImage:[UIImage imageNamed:@"侧滑按钮未点击"] forState:UIControlStateNormal];
    [menuBtn setImage:[UIImage imageNamed:@"侧滑按钮点击"] forState:UIControlStateHighlighted];
    [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:menuBtn];
    
    UIButton *switchoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchoverBtn setFrame:CGRectMake(214, 0, 44, 44)];
    [switchoverBtn setImage:[UIImage imageNamed:@"单屏未点击"] forState:UIControlStateNormal];
    [switchoverBtn setImage:[UIImage imageNamed:@"单屏点击"] forState:UIControlStateHighlighted];
    [switchoverBtn addTarget:self action:@selector(switchoverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self switchoverBtnClick:switchoverBtn];
    [_navView addSubview:switchoverBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(268, 0, 44, 44);
    [playBtn setImage:[UIImage imageNamed:@"首页播放"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"首页播放点击"] forState:UIControlStateHighlighted];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:playBtn];
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showToolView) userInfo:nil repeats:YES];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",IMAGE_PATH,@"Image.plist"]];
    NSArray *allImageArray = [self selectFile:IMAGE_PATH];
    
    if (!data)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsRequest"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsRequest"]) {
        [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:IMAMGE_URL,ALBUM_GUID]];
        NSLog(@"iamgeURL - %@",[NSString stringWithFormat:IMAMGE_URL,ALBUM_GUID]);
        [NetworkClass shareNetworkClass].delegate = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    
    if (allImageArray.count != data.count)
    {
        NSMutableArray *imageMutaleArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *imageDic in data)
        {
            [imageMutaleArray addObject:[imageDic objectForKey:@"picurl"]];
        }
        
        [[NetworkClass shareNetworkClass] downloadImages:imageMutaleArray];
        _imageArray = [[NetworkClass shareNetworkClass] imageArray];
    }
    else
    {
        _imageArray = allImageArray;
        [_qtmquitView reloadData];
    }
}

- (NSArray *)selectFile:(NSString *)filePath
{
    NSError * error= nil;
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * array = [fm contentsOfDirectoryAtPath:filePath
                                              error:&error];
    if(error)
    {
        NSLog(@"Error=%@",error);
        return 0;
    }
    else
    {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSString *fileName in array)
        {
            if ([fileName hasPrefix:@"photo"])
            {
                NSLog(@"path - %@",[NSString stringWithFormat:@"%@/%@",filePath,fileName]);
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",filePath,fileName]];
                [mutableArray addObject:image];
            }
        }
        return mutableArray;
    }
}

- (void)httpRequestMessage:(NSString *)message
{
    NSData *messageData = [[NSData alloc] initWithData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableLeaves error:nil];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = IMAGE_PATH;
    NSString *plistPath = [path stringByAppendingPathComponent:@"Image.plist"];
    [fm createFileAtPath:plistPath contents:nil attributes:nil];
    [resultArray writeToFile:plistPath atomically:YES];
    
    NSMutableArray *imageMutaleArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *imageDic in resultArray)
    {
        [imageMutaleArray addObject:[imageDic objectForKey:@"picurl"]];
    }
    
    [[NetworkClass shareNetworkClass] downloadImages:imageMutaleArray];
    _imageArray = [[NetworkClass shareNetworkClass] imageArray];
    
    [SVProgressHUD dismiss];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRequest"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_qtmquitView reloadData];
}

- (void)OutputErrorMessage:(NSString*) msg
{
    NSLog(@"message - %@",msg);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)setStatus
{
    _numberOfLine = 2;
    _isSwitchoverBtnClick = YES;
}

#pragma mark - TMQuiltViewDelegate
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return _imageArray.count;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return _numberOfLine;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *reuseIdentifier = @"PhotoCell";
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    [cell.photoView setImage:[_imageArray objectAtIndex:indexPath.row]];

//    cell.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;

}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [_imageArray objectAtIndex:indexPath.row];
    if (_numberOfLine == 1) {
        return image.size.height/2;
    }
    else
    {
        return image.size.height/4;
    }
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    WXC_PhotoViewController *photoViewController = [[WXC_PhotoViewController alloc] initWithImages:_imageArray Index:indexPath.row];
    [self presentModalViewController:photoViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _scrollViewEndY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollViewStartY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _scrollViewStartY = scrollView.contentOffset.y;
}

- (void)showToolView
{
    if (_scrollViewStartY - _scrollViewEndY == 0) {
        [UIView animateWithDuration:1 animations:^{
            _navView.frame = CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_BAR_HEIGHT);
        }];
    }
    else
    {
        [UIView animateWithDuration:.5 animations:^{
            _navView.frame = CGRectMake(0, -NAV_BAR_HEIGHT, MAIN_WINDOW_WIDTH, NAV_BAR_HEIGHT);
        }];
    }
}

#pragma mark - WXC_PhotoViewControllerDelegate
- (void)selectImageIndex:(int)index
{
    NSLog(@"index - %d",index);
}

- (void)setMenuClosed
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)menuBtnClick:(UIButton *)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)switchoverBtnClick:(UIButton *)sender
{
    if (_isSwitchoverBtnClick == NO) {
        _numberOfLine = 2;
        [sender setImage:[UIImage imageNamed:@"单屏未点击"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"单屏点击"] forState:UIControlStateHighlighted];
    }
    else{
        _numberOfLine = 1;
        [sender setImage:[UIImage imageNamed:@"双屏未点击"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"双屏点击"] forState:UIControlStateHighlighted];
    }
    _isSwitchoverBtnClick = !_isSwitchoverBtnClick;
    [_qtmquitView reloadData];

}

- (void)playBtnClick:(UIButton *)sender
{
    if (_imageArray.count) {
        WXC_AutoPlayViewController *autoPlayViewController = [[WXC_AutoPlayViewController alloc] initWithImages:_imageArray AndStartIndex:0];
        autoPlayViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve  ;
        [self presentViewController:autoPlayViewController animated:YES completion:^{
            
        }];
    }
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

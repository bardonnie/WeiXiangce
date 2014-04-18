//
//  WXC_StudioViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_StudioViewController.h"

@interface WXC_StudioViewController ()< UITableViewDataSource, UITableViewDelegate, WizSyncDownloadDelegate>
{
    UIImageView *_selectImageView;
    UIScrollView *_studioScrollView;
    BOOL _isHaveImage;
    NSString *_phoneNumber;
}

@end

@implementation WXC_StudioViewController

- (id)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self) {
        //        NSLog(@"dataArray - %@",dataArray);
        _docDataArray = [[NSArray alloc] initWithArray:dataArray];
        NSLog(@"count - %d",dataArray.count);
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
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    lineView.backgroundColor = [UIColor_Hex colorWithHex:0xe5e5e5];
    [navView addSubview:lineView];
    
    // tag - 300
    NSArray *navBarBtnNames = [[NSArray alloc] initWithObjects:@"返回",@"作品",@"套系",@"电话", nil];
    for (int i = 0; i<navBarBtnNames.count; i++)
    {
        UIButton *navBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
            navBarBtn.frame = CGRectMake(0, 0, 64, 44);
        else if (i == 1)
            navBarBtn.frame = CGRectMake(64, 0, 92, 44);
        else if (i == 2)
            navBarBtn.frame = CGRectMake(156, 0, 92, 44);
        else
            navBarBtn.frame = CGRectMake(248, 0, 64, 44);
        if (i == 0)
        {
            [navBarBtn setImage:[UIImage imageNamed:[navBarBtnNames objectAtIndex:i]] forState:UIControlStateNormal];
            [navBarBtn setImage:[UIImage imageNamed:@"返回点击"] forState:UIControlStateHighlighted];
        }else if (i == 3) {
            [navBarBtn setImage:[UIImage imageNamed:[navBarBtnNames objectAtIndex:i]] forState:UIControlStateNormal];
            [navBarBtn setImage:[UIImage imageNamed:@"电话点击"] forState:UIControlStateHighlighted];
        }
        else
            [navBarBtn setTitle:[navBarBtnNames objectAtIndex:i] forState:UIControlStateNormal];
        [navBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        navBarBtn.tag = i+300;
        [navBarBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:navBarBtn];
    }
    
    _selectImageView = [[UIImageView alloc] init];
    _selectImageView.frame = CGRectMake(66, 41, 87, 3);
    [_selectImageView setImage:[UIImage imageNamed:@"作品滑动条"]];
    [navView addSubview:_selectImageView];
    
    // tag - 500
    _studioScrollView = [[UIScrollView alloc] init];
    _studioScrollView.frame = CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT);
    _studioScrollView.contentSize = CGSizeMake(320*2, NAV_VIEW_HEIGHT);
    _studioScrollView.pagingEnabled = YES;
    _studioScrollView.delegate = self;
    _studioScrollView.tag = 500;
    _studioScrollView.backgroundColor = PNGrey;
    [self.view addSubview:_studioScrollView];
    
    // tag - 400
    for (int i = 0; i<2; i++) {
        UITableView *productionTableView = [[UITableView alloc] init];
        productionTableView.frame = CGRectMake(320*i, 0, 320, NAV_VIEW_HEIGHT);
        productionTableView.delegate = self;
        productionTableView.dataSource = self;
        productionTableView.tag = i+400;
        productionTableView.backgroundColor = [UIColor whiteColor];
        [_studioScrollView addSubview:productionTableView];
    }
    [self parserRecommendText];
}

#pragma mark - productionTableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_docDataArray.count) {
        if (tableView.tag == 400)
            return [[_docDataArray objectAtIndex:0] count];
        else
            return [[_docDataArray objectAtIndex:1] count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    WXC_ProductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[WXC_ProductionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    WizDocument *wizDocument;
    if (tableView.tag == 400) {
        wizDocument = (WizDocument *)[[_docDataArray objectAtIndex:0] objectAtIndex:indexPath.row];
        cell.nameLabel.textColor = [UIColor_Hex colorWithHex:0xbd8b05];
    }
    else if (tableView.tag == 401)
    {
        wizDocument = (WizDocument *)[[_docDataArray objectAtIndex:1] objectAtIndex:indexPath.row];
        cell.nameLabel.textColor = [UIColor_Hex colorWithHex:0x48bb7f];
    }
    else{
        
    }
    
    _isHaveImage = NO;
    NSString *tmp = NSTemporaryDirectory();
    NSString *tmpPath = [tmp stringByAppendingPathComponent:wizDocument.guid];
    NSString *tmpPathIndex = [tmpPath stringByAppendingPathComponent:@"index_files"];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpPathIndex error:nil];
    for (NSString *fileName in files) {
        NSRange jpgRange = [fileName rangeOfString:@".jpg"];
        NSRange pngRange = [fileName rangeOfString:@".png"];
        if (jpgRange.length > 0 || pngRange.length > 0) {
            NSString *imagePath = [tmpPathIndex stringByAppendingPathComponent:fileName];
            cell.thumbnailImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            _isHaveImage = YES;
        }
    }
    
    if (_isHaveImage == NO) {
        cell.thumbnailImageView.hidden = YES;
        cell.nameLabel.frame = CGRectMake(25, 10, 270, 20);
        cell.detailLabel.frame = CGRectMake(25, 30, 270, 60);
        _isHaveImage = YES;
    }
    
    NSArray *textArray = [wizDocument.title componentsSeparatedByString:@"@"];
    cell.nameLabel.text = [textArray objectAtIndex:0];
    if (textArray.count > 1) {
        cell.detailLabel.text = [textArray objectAtIndex:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WizDocument *document = [[_docDataArray objectAtIndex:(tableView.tag-400)] objectAtIndex:indexPath.row];
    NSArray *textArray = [document.title componentsSeparatedByString:@"@"];
    
    WXC_ProductionDetailViewController *productionDetailViewController = [[WXC_ProductionDetailViewController alloc] initWithGuid:document.guid AndProductionTitle:[textArray objectAtIndex:0]];
    [self.navigationController pushViewController:productionDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - studioScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag == 500)
        [self scroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 500)
        [self scroll:scrollView];
}

- (void)scroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 320)
    {
        [UIView animateWithDuration:.2 animations:^{
            _selectImageView.frame = CGRectMake(156, 41, 87, 3);
            [_selectImageView setImage:[UIImage imageNamed:@"套系滑动条"]];
        }];
    }
    else if (scrollView.contentOffset.x == 0)
    {
        [UIView animateWithDuration:.2 animations:^{
            _selectImageView.frame = CGRectMake(66, 41, 87, 3);
            [_selectImageView setImage:[UIImage imageNamed:@"作品滑动条"]];
        }];
    }
}

// 压缩图片
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext (newSize);
    // Tell the old image to draw in this newcontext, with the desired
    // new size
    [image  drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    // Get the new image from the context
    UIImage * newImage =  UIGraphicsGetImageFromCurrentImageContext ();
    // End the context
    UIGraphicsEndImageContext ();
    // Return the new image.
    return  newImage;
}

- (void)parserRecommendText
{
    NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:PHONE_NUMBER];
    if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
    {
        [[WizNotificationCenter shareCenter] addDownloadDelegate:self];
        [[WizSyncCenter shareCenter] downloadDocument:PHONE_NUMBER kbguid:KBGUID accountUserId:USER_ID];
    }
    else
    {
        [self didDownloadEnd:PHONE_NUMBER];
    }
}

- (void)didDownloadEnd:(NSString *)guid
{
    NSLog(@"guid -- %@",guid);
    if ([guid isEqualToString:PHONE_NUMBER]) {
        NSString *filePathString = [[WizFileManager shareManager] documentIndexFilePath:guid];
        if (![[WizFileManager shareManager] fileExistsAtPath:filePathString])
        {
            [[WizFileManager shareManager] prepareReadingEnviroment:guid accountUserId:USER_ID];
        }
        _phoneNumber = [[NSString alloc] initWithString:[[NetworkClass shareNetworkClass] parserRecommendText:filePathString]];
    }
}

- (void)navBarBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 300:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 301:
            [_studioScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 302:
            [_studioScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
            break;
        case 303:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",@"15076682001"]]];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

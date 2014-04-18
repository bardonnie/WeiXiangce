//
//  WXC_ActivityViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_ActivityViewController.h"

@interface WXC_ActivityViewController ()< UITableViewDataSource, UITableViewDelegate, WizSyncDownloadDelegate>
{
    BOOL _isHaveImage;
    NSString *_phoneNumber;
    NSString *_activityTitle;
}

@end

@implementation WXC_ActivityViewController

- (id)initWithDataArray:(NSArray *)dataArray AndTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        NSLog(@"dataArray - %@",dataArray);
        _dataArray = [NSArray arrayWithArray:dataArray];
        _activityTitle = [NSString stringWithString:title];
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

    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, IOS7_STATUS_BAR_HEIGHT, 320, NAV_BAR_HEIGHT);
    navLabel.backgroundColor = [UIColor whiteColor];
    navLabel.text = _activityTitle;
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [self.view addSubview:navLabel];
    
    // tag - 600
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回点击"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 600;
    [navLabel addSubview:backBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(256, 0, 64, 44);
    [callBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"电话点击"] forState:UIControlStateHighlighted];
    [callBtn addTarget:self action:@selector(navBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.tag = 601;
    [navLabel addSubview:callBtn];
    
    UITableView *activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_OR_LATER_Y, 320, NAV_VIEW_HEIGHT) style:UITableViewStylePlain];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:activityTableView];
    
    UIImageView *sideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_AND_NAV_BAR_HEIGHT, MAIN_WINDOW_WIDTH, 9)];
    [sideImageView setImage:[UIImage imageNamed:@"曲线边"]];
    [self.view addSubview:sideImageView];
    
    [self parserRecommendText];
}

#pragma mark - activityTableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    WXC_ProductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[WXC_ProductionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor_Hex colorWithHex:0xf1f1f1];
    }
    
    WizDocument *wizDocument = [_dataArray objectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WizDocument *document = [_dataArray objectAtIndex:indexPath.row];
    NSArray *textArray = [document.title componentsSeparatedByString:@"@"];
    
    WXC_ProductionDetailViewController *productionDetailViewController = [[WXC_ProductionDetailViewController alloc] initWithGuid:document.guid AndProductionTitle:[textArray objectAtIndex:0]];
    [self.navigationController pushViewController:productionDetailViewController animated:YES];
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
    if (sender.tag == 600)
        [self.navigationController popViewControllerAnimated:YES];
    else if (sender.tag == 601)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",@"15076682001"]]];
    else
        NSLog(@"Error");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

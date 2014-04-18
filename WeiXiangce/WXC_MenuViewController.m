//
//  WXC_MenuViewController.m
//  WeiXiangce
//
//  Created by mac on 13-12-14.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_MenuViewController.h"

@interface WXC_MenuViewController ()< UIActionSheetDelegate, WizSyncDownloadDelegate, SKSTableViewDelegate>
{
    WXC_ShareView *_shareView;
    NSString *_phoneNumber;
    NSArray *_partArray;
}

@end

@implementation WXC_MenuViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor_Hex colorWithHex:0xf7f1dc];
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *aboutMengMaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutMengMaoBtn.frame = CGRectMake(10, MAIN_WINDOW_HEIGHT-43, 33, 33);
    [aboutMengMaoBtn setImage:[UIImage imageNamed:@"关于萌猫副本"] forState:UIControlStateNormal];
    [aboutMengMaoBtn setImage:[UIImage imageNamed:@"关于萌猫按下"] forState:UIControlStateHighlighted];
    [aboutMengMaoBtn addTarget:self action:@selector(aboutMengMaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutMengMaoBtn];
    
    UIButton *aboutStudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutStudioBtn.frame = CGRectMake( RIGHT_CONTERLLER_WIDTH-43, MAIN_WINDOW_HEIGHT-43, 33, 33);
    [aboutStudioBtn setImage:[UIImage imageNamed:@"关于影楼副本"] forState:UIControlStateNormal];
    [aboutStudioBtn setImage:[UIImage imageNamed:@"关于影楼按下"] forState:UIControlStateHighlighted];
    [aboutStudioBtn addTarget:self action:@selector(aboutStudioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutStudioBtn];
    
    _shareView = [[WXC_ShareView alloc] initWithFrame:CGRectMake(0, MAIN_WINDOW_HEIGHT, LEFT_CONTERLLER_WIDTH, SHAREVIEW_HEIGHT)];
    _shareView.shareClickType = AlbumShare;
    [self.view addSubview:_shareView];
    
    [self parserRecommendText];
    
    SKSTableView *menuTableView = [[SKSTableView alloc] initWithFrame:CGRectMake(0, 0, LEFT_CONTERLLER_WIDTH, MAIN_WINDOW_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    menuTableView.backgroundColor = [UIColor clearColor];
    menuTableView.SKSTableViewDelegate = self;
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:menuTableView];
    
    _partArray = @[@[@"作品&套系",@"作品套系副本",@"最新活动",@"最新活动副本",@"推荐好友",@"推荐好友副本",@"分享相册",@"分享相册副本",@"摄影评分",@"摄影评分副本",@"电话咨询",@"电话咨询副本"],@[@"育儿知识",@"育儿知识副本",@"母婴健康",@"母婴健康副本",@"早期教育",@"早期教育副本",@"妈妈厨房",@"妈妈厨房副本",@"亲子游戏",@"亲子游戏副本"]];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _partArray.count;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_partArray objectAtIndex:indexPath.row] count]/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0)
        cell.textLabel.text = STUDIO_NAME;
    else
        cell.textLabel.text = @"合格妈妈";
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    cell.isExpandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[_partArray objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow*2-2];
    cell.imageView.image = [UIImage imageNamed:[[_partArray objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow*2-1]];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = indexPath.row*100+indexPath.subRow;
    cell.contentView.backgroundColor = [UIColor_Hex colorWithHex:0xf7f1dc];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"path - %d",[tableView cellForRowAtIndexPath:indexPath].tag);
    
    WXC_AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *dataArray = [NetworkClass shareNetworkClass].wizDocDataArray;
    switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
        case 1:
        {
            WXC_StudioViewController *studioViewController = [[WXC_StudioViewController alloc] initWithDataArray:dataArray];
            [delegate.rootNavigationController pushViewController:studioViewController animated:YES];
        }
            break;
        case 2:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:2] AndTitle:@"最新活动"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
        }
            break;
        case 3:
        {
            WXC_RecommendViewController *recommendViewController = [[WXC_RecommendViewController alloc] init];
            [delegate.rootNavigationController pushViewController:recommendViewController animated:YES];
        }
            break;
        case 4:
        {
            [_shareView moveViewAndShow];
        }
            break;
        case 5:
        {
            WXC_GradeViewController *gradeViewController = [[WXC_GradeViewController alloc] init];
            [delegate.rootNavigationController pushViewController:gradeViewController animated:YES];
        }
            break;
        case 6:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",@"15076682001"]]];
        }
            break;
        case 101:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:3] AndTitle:@"育儿知识"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
            NSLog(@"育儿知识");
        }
            break;
        case 102:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:4] AndTitle:@"母婴健康"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
            NSLog(@"母婴健康");
        }
            break;
        case 103:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:5] AndTitle:@"早期教育"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
            NSLog(@"早期教育");
        }
            break;
        case 104:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:6] AndTitle:@"妈妈厨房"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
            NSLog(@"妈妈厨房");
        }
            break;
        case 105:
        {
            WXC_ActivityViewController *activityViewController = [[WXC_ActivityViewController alloc] initWithDataArray:[dataArray objectAtIndex:7] AndTitle:@"亲子游戏"];
            [delegate.rootNavigationController pushViewController:activityViewController animated:YES];
            NSLog(@"亲子游戏");
        }
            break;
        default:
            break;
    }
    
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

- (void)aboutMengMaoBtnClick
{
    WXC_BoundViewController *boundViewController = [[WXC_BoundViewController alloc] init];
    [self presentModalViewController:boundViewController animated:YES];
}

- (void)menuBtnClick:(UIButton *)sender
{
    
}

- (void)aboutStudioBtnClick:(UIButton *)sender
{
    WXC_AboutViewController *aboutViewController = [[WXC_AboutViewController alloc] init];
    [self presentViewController:aboutViewController animated:YES completion:^{
        
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

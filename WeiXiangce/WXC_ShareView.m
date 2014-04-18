//
//  WXC_ShareView.m
//  WeiXiangce
//
//  Created by mac on 13-12-31.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_ShareView.h"

#define SHARE_URL           [NSString stringWithFormat:@"http://mmao.org.cn/IOS_%@.aspx",USER_NAME_PINYIN]
#define SHARE_TEXT_ALBUM    [NSString stringWithFormat:@"我正在用萌猫浏览%@的%@，快来下载欣赏更多她们的照片~  下载链接:%@",USER_NAME,SHARE_TYPE,SHARE_URL]
#define SHARE_TEXT_PHOTO    [NSString stringWithFormat:@"我正在用萌猫浏览%@拍摄的%@的%@，快来下载欣赏更多他们的照片吧~  下载链接:%@",STUDIO_NAME,USER_NAME,SHARE_TYPE,SHARE_URL]
#define SHARE_TEXT_ARTICLE  @"%@\n%@\n来自于:%@"
#define SHARE_TEXT_TITLE    [NSString stringWithFormat:@"%@ 萌猫出品",STUDIO_NAME]

@implementation WXC_ShareView
{
    CGRect _frame;
    UIControl *_deControl;
}

@synthesize shareClickType = _shareClickType;
@synthesize shareImage = _shareImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"frame - %f",frame.size.width);
        _frame = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *shareBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-42)];
        [shareBackImageView setImage:[UIImage imageNamed:@"侧滑图标底图"]];
        shareBackImageView.userInteractionEnabled = YES;
        [self addSubview:shareBackImageView];
        
        NSArray *shareBtnImagesArray = [[NSArray alloc] initWithObjects:@"微信", @"朋友圈",@"微博",@"qq",@"qq空间",@"邮件", nil];
        
        // tag - 1200
        for (int i = 0; i<shareBtnImagesArray.count; i++) {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(IS_MENU_START+IS_MENU_SPACE*(i%3), 14+66*(i/3), 52, 52);
            [shareBtn setImage:[UIImage imageNamed:[shareBtnImagesArray objectAtIndex:i]] forState:UIControlStateNormal];
            shareBtn.tag = 1200+i;
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareBackImageView addSubview:shareBtn];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, frame.size.height-40, frame.size.width, 40);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"侧滑取消"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
    }
    return self;
}

- (void)moveViewAndShow
{
    NSLog(@"shareType - %d",_shareClickType);
    NSLog(@"image - %@",_shareImage);
    if (self.frame.origin.y == MAIN_WINDOW_HEIGHT) {
        _deControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, MAIN_WINDOW_HEIGHT)];
        _deControl.backgroundColor = [UIColor blackColor];
        [_deControl addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _deControl.alpha = .5;
        [self.superview addSubview:_deControl];
        [self.superview bringSubviewToFront:self];
        
        [Animations moveUp:self andAnimationDuration:0.2 andWait:YES andLength:_frame.size.height];
        [Animations moveDown:self andAnimationDuration:0.2 andWait:YES andLength:5.0];
        [Animations moveUp:self andAnimationDuration:0.1 andWait:YES andLength:5.0];
    }
}

- (void)shareBtnClick:(UIButton *)sender
{
    NSLog(@"image - %@",_shareImage);
    id<ISSContent> content;
    switch (_shareClickType) {
        case AlbumShare:
            content = [ShareSDK content:SHARE_TEXT_ALBUM
                         defaultContent:nil
                                  image:nil
                                  title:SHARE_TEXT_TITLE
                                    url:SHARE_URL
                            description:SHARE_TEXT_ALBUM
                              mediaType:SSPublishContentMediaTypeText];
            break;
        case PhotoShare:
//            320x480
            content = [ShareSDK content:SHARE_TEXT_ALBUM
                         defaultContent:nil
                                  image:nil
                                  title:SHARE_TEXT_TITLE
                                    url:SHARE_URL
                            description:SHARE_TEXT_ALBUM
                              mediaType:SSPublishContentMediaTypeText];
            break;
        case ArticleShare:
            content = [ShareSDK content:SHARE_TEXT_PHOTO
                         defaultContent:nil
                                  image:[ShareSDK jpegImageWithImage:_shareImage quality:1]
                                  title:SHARE_TEXT_TITLE
                                    url:SHARE_URL
                            description:SHARE_TEXT_PHOTO
                              mediaType:SSPublishContentMediaTypeText];
            break;
        default:
            break;
    }
    
//    content = [ShareSDK content:[NSString stringWithFormat:SHARE_TEXT,USER_NAME,SHARE_TYPE,[NSString stringWithFormat:SHARE_URL,USER_NAME_PINYIN]]
//                 defaultContent:nil
//                          image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"爱秀相册.png"] quality:1]
//                          title:[NSString stringWithFormat:SHARE_TEXT,USER_NAME,SHARE_TYPE,[NSString stringWithFormat:SHARE_URL,USER_NAME_PINYIN]]
//                            url:@"http://www.panker.cn/"
//                    description:nil
//                      mediaType:SSPublishContentMediaTypeText];
    
    
    [[NetworkClass shareNetworkClass] httpRequest:[NSString stringWithFormat:STATISTICS_URL,KBGUID,@"-1",@"3"]];
    
    switch (sender.tag) {
        case 1200:
        {
            [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:nil];
        }
            break;
        case 1201:
        {
            [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:nil];
        }
            break;
        case 1202:
        {
            id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
            
            [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:shareOptions
                                     result:nil];
        }
            break;
        case 1203:
        {
            [ShareSDK showShareViewWithType:ShareTypeQQ
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:nil];
        }
            break;
        case 1204:
        {
            id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
            
            [ShareSDK showShareViewWithType:ShareTypeQQSpace
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:shareOptions
                                     result:nil];
        }
            break;
        case 1205:
        {
            //显示分享菜单
            [ShareSDK showShareViewWithType:ShareTypeMail
                                  container:nil
                                    content:content
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:nil];
            
        }
            break;
        case 1206:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)cancelBtnClick
{
    [_deControl removeFromSuperview];
    [Animations moveDown:self andAnimationDuration:0.2 andWait:YES andLength:_frame.size.height];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

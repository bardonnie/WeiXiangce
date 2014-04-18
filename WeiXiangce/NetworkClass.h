//
//  NetworkClass.h
//  WeiXiangce
//
//  Created by mac on 13-12-24.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#define CLASSIC_GUID        [STDUIO_DIC objectForKey:@"classic_guid"]
#define PRODUCTION_GUID     [STDUIO_DIC objectForKey:@"production_guid"]
#define ACTIVITY_GUID       [STDUIO_DIC objectForKey:@"activity_guid"]

#define Mummy_Kitchen           [STDUIO_DIC objectForKey:@"Mummy_Kitchen"]
#define Maternal_Child_Health   [STDUIO_DIC objectForKey:@"Maternal_Child_Health"]
#define Family_games            [STDUIO_DIC objectForKey:@"Family_games"]
#define Parental_knowledge      [STDUIO_DIC objectForKey:@"Parental_knowledge"]
#define Early_Education         [STDUIO_DIC objectForKey:@"Early_Education"]


#pragma mark - pankerServer
//http://albuminterface.panker.cn/
// 推荐好友
#define RECOMMEND_URL   @"http://albuminterface.panker.cn/index.aspx?_action=RecommendFriend&rname=%@&tel=%@&rtype=%@&source=1&albumGuid=%@&customername=%@"
// 获取推荐好友数量
#define REALBUM_URL     @"http://albuminterface.panker.cn/index.aspx?_action=GetReNumByAlbumGuid&albumGuid=%@"
// 添加相册
#define ADDALBUM_URL    @"http://albuminterface.panker.cn/index.aspx?_action=AddAlbum&albumGuid=%@&albumName=%@"
// 添加板块
#define ADDBOARD_URL    @"http://albuminterface.panker.cn/index.aspx?_action=AddBoard&albumGuid=%@&boardGuid=%@&boardName=%@&boardType=%@"
// 添加客户
#define ADDCUSTOMER_URL @"http://albuminterface.panker.cn/index.aspx?_action=AddCustomer&albumGuid=%@&customerName=%@&albumType=%@&source=1"
// 添加文章
#define ADDARTICLE_URL  @"http://albuminterface.panker.cn/index.aspx?_action=AddArticle&itemGuid=%@&itemName=%@&itemType=%@&boardGuid=%@"
// 统计接口
#define STATISTICS_URL  @"http://albuminterface.panker.cn/index.aspx?_action=Statistics&itemGuid=%@&type=%@&action=%@&source=1"
// 添加评分
#define ADDGRADE_URL    @"http://albuminterface.panker.cn/index.aspx?_action=AddGrade&albumGuid=%@&source=1&content=%@&cameraman=%@&dresser=%@&result=%@&service=%@&tel=%@&customerName=%@"
// 首页图片
#define IMAMGE_URL      @"http://albuminterface.panker.cn/index.aspx?_action=GetPicListByDocumentGuid&documentGuid=%@"

#define IMAGE_PATH      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#import <Foundation/Foundation.h>

//1
@protocol NetworkClassDelegate <NSObject>

- (void)httpRequestMessage:(NSString *)message;

@end

@interface NetworkClass : NSObject< WizSyncKbDelegate, WizSyncDownloadDelegate, ASIHTTPRequestDelegate>
{
    //2
    __weak id< NetworkClassDelegate> _delegate;
    NSArray *_wizDocDataArray;
    NSMutableArray *_imageArray;
    
    NSString *_versionNum;
    NSString *_appName;
    
    NSString *_friendName;
    NSString *_friendPhone;
    
    NSString *_recommText;
}
//3
@property (weak, nonatomic) __weak id< NetworkClassDelegate> delegate;
@property (strong, nonatomic) NSArray *wizDocDataArray;
@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) NSString *versionNum;
@property (strong, nonatomic) NSString *appName;

@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSString *friendPhone;

+ (NetworkClass *)shareNetworkClass;

- (void)downloadWizDataBase;
- (void)httpRequest:(NSString *)urlString;
- (NSString *)parserRecommendText:(NSString *)path;
- (void)downloadImages:(NSArray *)imageUrlArray;



@end

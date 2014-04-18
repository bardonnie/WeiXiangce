//
//  NetworkClass.m
//  WeiXiangce
//
//  Created by mac on 13-12-24.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "NetworkClass.h"

@implementation NetworkClass
// 4
@synthesize delegate = _delegate;
@synthesize wizDocDataArray = _wizDocDataArray;
@synthesize imageArray = _imageArray;

@synthesize versionNum = _versionNum;
@synthesize appName = _appName;

@synthesize friendName = _friendName;
@synthesize friendPhone = _friendPhone;

static NetworkClass *_shareNetworkClass;

+(NetworkClass *)shareNetworkClass
{
    if (!_shareNetworkClass) {
        _shareNetworkClass = [[NetworkClass alloc] init];
    }
    return _shareNetworkClass;
}

- (void)httpRequest:(NSString *)urlString
{
    NSString *utf8sStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:utf8sStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    
    NSLog(@"url = %@",urlString);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Finishedrequest - %@",request.responseString);
    
    [_delegate httpRequestMessage:request.responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failedrequest - %@",request);
}

- (void)downloadWizDataBase
{
    NSLog(@"wizDataIsDownload...");
    
    //判断当前的网络是3g还是wifi
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    if ([reachability currentReachabilityStatus] == ReachableViaWiFi)
    {
        [[WizNotificationCenter shareCenter] addSyncKbObserver:self];
        [[WizAccountManager defaultManager] registerActiveAccount:USER_ID];
        [[WizSyncCenter shareCenter] syncAccount:USER_ID password:USER_PWD isGroup:YES isUploadOnly:NO];
    }
    else
    {
        [self didSyncKbEnd:KBGUID];
    }
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    _versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    _appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    
}

- (void)didSyncKbEnd:(NSString *)kbguid
{
    NSLog(@"kbguid - %@",kbguid);
    if ([kbguid isEqualToString:KBGUID]) {
        _wizDocDataArray = [[NSArray alloc] initWithArray:[self accountManager:kbguid]];
        
        [[WizSettings defaultSettings]setOfflineDownloadDuration:WizOfflineDownloadLastMonth kbguid:KBGUID  accountUserId:USER_ID];
        [[WizAutoDownloadThread shareInstance]cancelAllWork];
        [[WizSyncCenter shareCenter]autoDownloadDocumentByKbguid:KBGUID  accountUserId:USER_ID];
    }
}

- (void)didSyncKbFaild:(NSString *)kbguid error:(NSError *)error
{
    NSLog(@"error - %@",error);
}

- (void)didSyncKbStart:(NSString *)kbguid
{
    NSLog(@"startKbguid - %@",kbguid);
}

- (NSMutableArray *)accountManager:(NSString *)kbGuid
{
    [[WizAccountManager defaultManager] updateAccount:USER_ID password:USER_PWD personalKbguid:kbGuid];
    [[WizAccountManager defaultManager] registerActiveAccount:USER_ID];
    
    id<WizInfoDatabaseDelegate>dataDelegate = [WizDBManager getMetaDataBaseForKbguid:kbGuid accountUserId:USER_ID];
    
    NSArray *tagguidArray = [[NSArray alloc] initWithObjects:PRODUCTION_GUID, CLASSIC_GUID, ACTIVITY_GUID, Parental_knowledge, Maternal_Child_Health, Early_Education, Mummy_Kitchen, Family_games, nil];
    NSMutableArray *articleArray = [[NSMutableArray alloc] init];
    // 文章数组
    for (int i = 0; i<tagguidArray.count; i++)
    {
        NSMutableArray *array =(NSMutableArray *)[dataDelegate documentsByTag:[tagguidArray objectAtIndex:i]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
        [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [articleArray addObject:array];
    }
    NSLog(@"articleArray.count - %d",articleArray.count);
    
    for (NSMutableArray* eachArray in articleArray) {
        [eachArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WizDocument* doc1 = (WizDocument*)obj1;
            WizDocument* doc2 = (WizDocument*)obj2;
            return [doc2.dateModified compare:doc1.dateModified];
        }];
    }
    return articleArray;
}

- (NSString *)parserRecommendText:(NSString *)path
{
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF16StringEncoding error:NULL];
    
    // 解析HTML
    NSData *data = [html dataUsingEncoding:NSUTF16StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//body"];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (TFHppleElement *element in elements) {
        if ([element content]!=nil)
        {
            //                NSLog(@"%@",[element content]);
            [str appendString:[element content]];
        }
    }
    return str;
}

// 现在保存图片
- (void)downloadImages:(NSArray *)imageUrlArray
{
    NSString * documentsDirectoryPath = IMAGE_PATH;
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    
    _imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<imageUrlArray.count; i++)
    {
        NSString *imageUrl = [imageUrlArray objectAtIndex:i];
        UIImage * imageFromURL = [self getImageFromURL:imageUrl];
        [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"photo_%d",i] ofType:@"jpg" inDirectory:documentsDirectoryPath];
        UIImage * imageFromWeb = [self loadImage:[NSString stringWithFormat:@"photo_%d",i] ofType:@"jpg" inDirectory:documentsDirectoryPath];
        [_imageArray addObject:imageFromWeb];
    }
}

- (UIImage *)getImageFromURL:(NSString *)fileURL
{
    NSLog(@"执行图片下载函数");
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    UIImage * result = [UIImage imageWithData:data];
    
    return result;
}

- (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else{
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

- (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    return result;
}


@end

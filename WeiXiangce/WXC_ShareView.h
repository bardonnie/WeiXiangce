//
//  WXC_ShareView.h
//  WeiXiangce
//
//  Created by mac on 13-12-31.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AlbumShare = 1,
    PhotoShare,
    ArticleShare
}ShareClickType;

@interface WXC_ShareView : UIView
{
    UIImage *_shareImage;
    ShareClickType _shareClickType;
}

@property (nonatomic) ShareClickType shareClickType;
@property (strong, nonatomic) UIImage *shareImage;

- (void)moveViewAndShow;

@end

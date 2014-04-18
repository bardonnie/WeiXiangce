//
//  WXC_PlatformTableViewCell.h
//  WeiXiangce
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_PlatformTableViewCell : UITableViewCell
{
    UILabel *_platformNameLabel;
    UILabel *_platformBoundLabel;
}

@property (strong, nonatomic) UILabel *platformNameLabel;
@property (strong, nonatomic) UILabel *platformBoundLabel;

@end

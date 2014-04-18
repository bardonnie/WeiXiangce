//
//  WXC_ProductionTableViewCell.h
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_ProductionTableViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_detailLabel;
    UIImageView *_thumbnailImageView;
    BOOL _isHaveImage;
}

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *thumbnailImageView;
@property (nonatomic) BOOL isHaveImage;

@end

//
//  WXC_MenuButton.h
//  WeiXiangce
//
//  Created by mac on 13-12-15.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_MenuButton : UIButton
{
    UILabel *_titleLabel;
    UIImageView *_titleImageView;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleImageView;

@end

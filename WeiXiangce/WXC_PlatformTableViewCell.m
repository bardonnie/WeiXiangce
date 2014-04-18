//
//  WXC_PlatformTableViewCell.m
//  WeiXiangce
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_PlatformTableViewCell.h"

@implementation WXC_PlatformTableViewCell

@synthesize platformNameLabel = _platformNameLabel;
@synthesize platformBoundLabel = _platformBoundLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *platformBackView = [[UIView alloc] init];
        platformBackView.frame = CGRectMake(20, 0, 280, 43);
        platformBackView.backgroundColor = [UIColor_Hex colorWithHex:0xecc55c];
        [self.contentView addSubview:platformBackView];
        
        UIImage *arrowImage = [UIImage imageNamed:@"社交账号箭头"];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(262, 14, arrowImage.size.width, arrowImage.size.height);
        [arrowImageView setImage:arrowImage];
        [platformBackView addSubview:arrowImageView];
        
        _platformNameLabel = [[UILabel alloc] init];
        _platformNameLabel.frame = CGRectMake(10, 12, 200, 20);
        _platformNameLabel.backgroundColor = [UIColor clearColor];
        _platformNameLabel.font = [UIFont systemFontOfSize:16];
        [platformBackView addSubview:_platformNameLabel];
        
        _platformBoundLabel = [[UILabel alloc] init];
        _platformBoundLabel.frame = CGRectMake(210, 12, 50, 20);
        _platformBoundLabel.backgroundColor = [UIColor clearColor];
        _platformBoundLabel.font = [UIFont systemFontOfSize:16];
        [platformBackView addSubview:_platformBoundLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

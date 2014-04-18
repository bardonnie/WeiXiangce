//
//  WXC_ProductionTableViewCell.m
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_ProductionTableViewCell.h"

@implementation WXC_ProductionTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize detailLabel = _detailLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize isHaveImage = _isHaveImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(25, 10, 170, 20);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.frame = CGRectMake(25, 30, 170, 60);
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_detailLabel];
        
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.frame = CGRectMake(210, 5, 80, 80);
        _thumbnailImageView.backgroundColor = [UIColor orangeColor];
        _thumbnailImageView.layer.cornerRadius = 10;
        _thumbnailImageView.clipsToBounds = YES;
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_thumbnailImageView];
        
        if (_isHaveImage == YES) {
            _thumbnailImageView.hidden = YES;
            _nameLabel.frame = CGRectMake(25, 10, 270, 20);
            _detailLabel.frame = CGRectMake(25, 30, 270, 60);
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

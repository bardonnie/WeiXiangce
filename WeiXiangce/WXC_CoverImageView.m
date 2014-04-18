//
//  WXC_CoverImageView.m
//  WeiXiangce
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import "WXC_CoverImageView.h"

@implementation WXC_CoverImageView
{
    AnimationStyle _style;
    UILabel *_nameLabel;
    UILabel *_studioNameLabel;
}

@synthesize backImageView = _backImageView;

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT)];
        [self addSubview:_backImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAME_LABEL_FRAME, MAIN_WINDOW_WIDTH, NAV_BAR_HEIGHT)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = USER_NAME;
        _nameLabel.font = [UIFont boldSystemFontOfSize:36];
        _nameLabel.textColor = [UIColor_Hex colorWithHex:0xf5595c];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        _studioNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, MAIN_WINDOW_HEIGHT, 240, 28)];
        _studioNameLabel.backgroundColor = [UIColor clearColor];
        _studioNameLabel.font = [UIFont boldSystemFontOfSize:24];
        _studioNameLabel.textAlignment = NSTextAlignmentRight;
        _studioNameLabel.text = STUDIO_NAME;
        _studioNameLabel.textColor = [UIColor_Hex colorWithHex:0xa67900];
        [self addSubview:_studioNameLabel];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        NSLog(@"image - %f",image.size.height);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAnimation:(AnimationStyle)style
{
    NSLog(@"style - %d",style);
    _style = style;
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startAnimation) userInfo:nil repeats:NO];
    
    [Animations zoomIn:_nameLabel andAnimationDuration:2 andWait:NO];
    [Animations moveUp:_studioNameLabel andAnimationDuration:2 andWait:NO andLength:100];
}

- (void)startAnimation
{
    switch (_style) {
            // 放大
        case ZoomIn:
            [Animations zoomIn:_backImageView andAnimationDuration:1 andWait:YES];
            break;
            // 缩小
        case ButtonPressAnimate:
            [Animations buttonPressAnimate:_backImageView andAnimationDuration:3 andWait:YES];
            break;
            // 内渐变
        case FadeIn:
            [Animations fadeIn:_backImageView andAnimationDuration:1 andWait:YES];
            break;
            // 外渐变
        case FadeOut:
            [Animations fadeOut:_backImageView andAnimationDuration:1 andWait:YES];
            break;
            // 左移
        case MoveLeft:
            [Animations moveLeft:_backImageView andAnimationDuration:1 andWait:YES andLength:320];
            break;
            // 右移
        case MoveRight:
            [Animations moveRight:_backImageView andAnimationDuration:1 andWait:YES andLength:320];
            break;
            // 上移
        case MoveUp:
            [Animations moveUp:_backImageView andAnimationDuration:1 andWait:YES andLength:MAIN_WINDOW_HEIGHT];
            break;
            // 下移
        case MoveDown:
            [Animations moveDown:_backImageView andAnimationDuration:1 andWait:YES andLength:MAIN_WINDOW_HEIGHT];
            break;
            // 右转
        case Rotate:
            [Animations rotate:_backImageView andAnimationDuration:1 andWait:YES andAngle:90];
            break;
            // 左边和阴影
        case FrameAndShadow:
            [Animations frameAndShadow:_backImageView];
            break;
            // 加阴影
        case ShadowOnView:
            [Animations shadowOnView:_backImageView andShadowType:@"Trapezoidal"];
            break;
            // 加背景
        case Background:
            [Animations background:_backImageView andImageFileName:nil];
            break;
            // 旋转
        case RoundedCorners:
            [Animations roundedCorners:_backImageView];
            break;
        default:
            break;
    }
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0;
    }];
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

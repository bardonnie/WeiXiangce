//
//  WXC_CoverImageView.h
//  WeiXiangce
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ZoomIn,
    ButtonPressAnimate,
    FadeIn,
    FadeOut,
    MoveLeft,
    MoveRight,
    MoveUp,
    MoveDown,
    Rotate,
    FrameAndShadow,
    ShadowOnView,
    Background,
    RoundedCorners,
}AnimationStyle;

@interface WXC_CoverImageView : UIImageView
{
    UIImageView *_backImageView;
}

@property (strong, nonatomic) UIImageView *backImageView;

- (void)setAnimation:(AnimationStyle)style;

@end

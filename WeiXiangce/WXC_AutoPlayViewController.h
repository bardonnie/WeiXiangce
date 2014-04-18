//
//  WXC_AutoPlayViewController.h
//  WeiXiangce
//
//  Created by mac on 13-12-24.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXC_AutoPlayViewControllerDelegate <NSObject>

- (void)dismissControllerWithIndex:(int)index;

@end

@interface WXC_AutoPlayViewController : UIViewController
{
    __weak id<WXC_AutoPlayViewControllerDelegate> _delegate;
}

@property (weak , nonatomic) __weak id<WXC_AutoPlayViewControllerDelegate> delegate;

- (id)initWithImages:(NSArray *)images AndStartIndex:(int)index;

@end

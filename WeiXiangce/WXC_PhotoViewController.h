//
//  WXC_PhotoViewController.h
//  WeiXiangce
//
//  Created by mac on 13-12-17.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXC_PhotoViewControllerDelegate <NSObject>

- (void)selectImageIndex:(int)index;

@end

@interface WXC_PhotoViewController : UIViewController
{
    NSMutableArray *_photosArray;
    int _index;
    
    __weak id <WXC_PhotoViewControllerDelegate>_delegate;
}

@property (weak, nonatomic) __weak id <WXC_PhotoViewControllerDelegate>delegate;

- (id)initWithImages:(NSArray *)photos Index:(int)index;

@end

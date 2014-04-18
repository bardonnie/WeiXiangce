//
//  WXC_ActivityViewController.h
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_ActivityViewController : UIViewController
{
    NSArray *_dataArray;
}

- (id)initWithDataArray:(NSArray *)dataArray AndTitle:(NSString *)title;

@end

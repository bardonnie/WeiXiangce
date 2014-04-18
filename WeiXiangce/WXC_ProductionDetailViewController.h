//
//  WXC_ProductionDetailViewController.h
//  WeiXiangce
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXC_ProductionDetailViewController : UIViewController
{
    NSString *_guid;
    NSString *_productionTitle;
}

- (id)initWithGuid:(NSString *)guid AndProductionTitle:(NSString *)productionTitle;

@end

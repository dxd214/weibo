//
//  WeiboAnnotationView.h
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WXLabel.h"

@interface WeiboAnnotationView : MKAnnotationView<WXLabelDelegate>
{
    // 头像视图
    UIImageView *_userImageView;
    // 微博内容视图
    WXLabel *_textLabel;
    // 微博图片
    UIImageView *_weiboImageView;
    
}
@end

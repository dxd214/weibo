//
//  WeiboView.h
//  weibo
//
//  Created by zsm on 14-11-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "WeiboModel.h"
#import "ZoomImageView.h"
/*
    1. 只有微博文本
    2. 有微博文本，有微博图片
    3. 有微博文本，有转发微博文本 （背景图片）
    4. 有微博文本，有转发微博文本，有转发微博图片（背景图片）
 
    使用主题
    textColor :Mask_Title_color
    buttonTitleColor:Mask_Button_color
    连接颜色：Link_color
    选中颜色：Mask_TopTab_Selected_color
 */
@interface WeiboView : UIView<WXLabelDelegate>
{
    WXLabel *_weiboLabel;           //微博文本
    WXLabel *_reposterLabel;        //转发微博的文本
    ZoomImageView *_weiboImageView;   //微博图片
    UIImageView *_bgImageView;      //竹筏微博的背景图片
}

@property (assign, nonatomic) BOOL isDetail;
@property (strong, nonatomic) WeiboModel *weiboModel;
@end

//
//  RectButton.h
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton
{
    UILabel *_subTitileLabel;
    UILabel *_titleLabel;
}
@property(nonatomic,copy)NSString *subTitle;//子文本
@property(nonatomic,copy)NSString *title;//文本
@end

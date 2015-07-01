//
//  ThemeLabel.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel
@property (nonatomic,copy) NSString *textColorKey;
@property (nonatomic,copy) NSString *bgColorKey;


// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                 textColorKey:(NSString *)textColorKey
                   bgColorKey:(NSString *)bgColorKey;
@end

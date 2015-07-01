//
//  ThemeImageView.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,assign) float leftWidth;
@property (nonatomic,assign) float topHeight;


// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                    leftWidth:(float)leftWidth
                    topHeight:(float)topHeight
                    imageName:(NSString *)imageName;
@end

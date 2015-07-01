//
//  ThemeButton.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton
@property (nonatomic,copy) NSString *titleImageName;
@property (nonatomic,copy) NSString *titleImageHlName;
@property (nonatomic,copy) NSString *bgImageName;
@property (nonatomic,copy) NSString *bgImageHlName;


// 自定义初始化方法
// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
               titleImageName:(NSString *)titleImageName
             titleImageHlName:(NSString *)titleImageHlName
                  bgImageName:(NSString *)bgImageName
                bgImageHlName:(NSString *)bgImageHlName;
@end

//
//  Friend.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "Friend.h"

@implementation Friend

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        if (dict[@"friendId"] != nil) {
            [self setValuesForKeysWithDictionary:dict];
        } else {
            self.friendId = dict[@"idstr"];
            self.icon = dict[@"profile_image_url"];
            self.name = dict[@"screen_name"];
            self.intro = dict[@"description"];
            _vip = 0;
        }
    }
    return self;
}

@end

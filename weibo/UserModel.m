//
//  UserModel.m
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.userId = dic[@"id"];
        self.userDescription = dic[@"description"];
    }
    return self;
}
@end

//
//  CommentModel.m
//  weibo
//
//  Created by zsm on 14-11-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.commentId = dic[@"id"];
        self.userModel = [[UserModel alloc] initWithContentsOfDic:dic[@"user"]];
    }
    return self;
}
@end

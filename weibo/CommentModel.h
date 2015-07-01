//
//  CommentModel.h
//  weibo
//
//  Created by zsm on 14-11-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseModel.h"
/*
    "created_at": "Wed Jun 01 00:50:25 +0800 2011",
    "id": 12438492184,
    "text": "love your work.......",
    "source": "<a href="http:weibo.com" rel="nofollow">新浪微博</a>",
    "mid": "202110601896455629",
    "user": {
        "id": 1404376560,
        "screen_name": "zaku",
        "name": "zaku",
        "province": "11",
        "city": "5",
        "location": "北京 朝阳区",
        "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
        "url": "http:blog.sina.com.cn/zaku",
        "profile_image_url": "http:tp1.sinaimg.cn/1404376560/50/0/1",
        "domain": "zaku",
        "gender": "m",
        "followers_count": 1204,
        "friends_count": 447,
        "statuses_count": 2908,
        "favourites_count": 0,
        "created_at": "Fri Aug 28 00:00:00 +0800 2009",
        "following": false,
        "allow_all_act_msg": false,
        "remark": "",
        "geo_enabled": true,
        "verified": false,
        "allow_all_comment": true,
        "avatar_large": "http:tp1.sinaimg.cn/1404376560/180/0/1",
        "verified_reason": "",
        "follow_me": false,
        "online_status": 0,
        "bi_followers_count": 215
    }
*/
#import "UserModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *mid;
@property (nonatomic,strong) UserModel *userModel;


@end

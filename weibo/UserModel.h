//
//  UserModel.h
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

/*
     {
         "id": 1404376560,
         "screen_name": "zaku",
         "name": "zaku",
         "province": "11",
         "city": "5",
         "location": "北京 朝阳区",
         "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
         "url": "http://blog.sina.com.cn/zaku",
         "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
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
         "avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
         "verified_reason": "",
         "follow_me": false,
         "online_status": 0,
         "bi_followers_count": 215
     }
 */

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *userId;  //用户的id
@property (nonatomic,copy) NSString *screen_name;  //用户的名字
@property (nonatomic,copy) NSString *location;  //用户所在地
@property (nonatomic,copy) NSString *userDescription;  //用户个人描述
@property (nonatomic,copy) NSString *profile_image_url;  //用户头像地址（中图），50×50像素
@property (nonatomic,copy) NSNumber *followers_count; 	//粉丝数
@property (nonatomic,copy) NSNumber *friends_count;	//关注数
@property (nonatomic,copy) NSNumber *statuses_count;  //微博数
@property (nonatomic,copy) NSNumber *favourites_count;   //收藏数

@property (nonatomic,copy) NSString *created_at;  //发表时间
@property (nonatomic,copy) NSString *avatar_hd;  //用户头像地址（高清），高清头像原图
@property (nonatomic,copy) NSNumber *online_status;  //用户的在线状态，0：不在线、1：在线
@property(nonatomic,copy)NSString * gender;             //性别，m：男、f：女、n：未知

@end

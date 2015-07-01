//
//  FriendsViewController.h
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, FriendshipType)
{
    FriendshipTypeGuanZhu = 0,
    FriendshipTypeFans
    
};

@class FriendShipTableView;
@interface FriendsViewController : BaseViewController
{
    FriendShipTableView *_tableView;
}
@property(nonatomic,assign)FriendshipType shipType; //请求的是哪一个接口
@property(nonatomic,copy)NSString *userId; //用户的ID

@end

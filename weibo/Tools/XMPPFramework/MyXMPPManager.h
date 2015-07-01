//
//  MyXMPPManager.h
//  weibo
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef void(^SucccessBlock)(void);
typedef void(^FethFreindBlock)(NSArray *friends);

#define kReceiveMessageNotification @"ReceiveMessageNotification"
#define KService @"192.168.11.234"
#define kYuMing @"xmpp.wxhl.com"

@interface MyXMPPManager : NSObject<XMPPStreamDelegate> {
    
    XMPPStream *_xmppStream;
    XMPPRoster *_xmppRoster;
}

+ (instancetype)shareManager;

//登陆、注册的用户名、密码
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;

@property(nonatomic,copy)SucccessBlock loginBlock;  //登陆成功调用的block
@property(nonatomic,copy)SucccessBlock registerBlock; //注册成功调用的block
@property(nonatomic,copy)FethFreindBlock freindBlcok; //获取好友列表回调的block

//1.连接
- (BOOL)connect;

//2.断开连接
- (void)disconnect;

//3.上线
- (void)goOnline;

//4.离线
- (void)goOffline;


#pragma mark - 操作的功能

//1.登陆
- (void)login:(NSString *)username password:(NSString *)password
 successBlock:(SucccessBlock)successBlock;

//2.注册
- (void)registerUser:(NSString *)username password:(NSString *)password
        successBlock:(SucccessBlock)successBlock;

//3.发送消息
- (void)sendMessage:(NSString *)msg toUser:(NSString *)userJid;

//4.添加好友
- (void)addFreind:(NSString *)freindUser;

//5.获取好友列表
- (void)getFreind:(FethFreindBlock)freindBlock;

//...
@end

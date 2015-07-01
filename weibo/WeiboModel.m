//
//  WeiboModel.m
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.weiboId = dic[@"id"];
        
        self.userModel = [[UserModel alloc] initWithContentsOfDic:dic[@"user"]];
        
        if (dic[@"retweeted_status"]) {
            self.reWeibo = [[WeiboModel alloc] initWithContentsOfDic:dic[@"retweeted_status"]];
        }
        
    }
    
    return self;
}

/*
    扎实地发呆是[呵呵][神马]
    扎实地发呆是<image url = '呵呵.png'><image url = '神马.png'>
 */

- (void)setText:(NSString *)text
{
    if (_text != text) {
        // 把原有的文本转换成我们需要的文本格式
        _text = [self exChangedImageNameWithContent:text];
        
    }
}

/**
 *  把微博内容的文本，转换成WXLabel可以显示图片的文本格式
 *
 *  @param content 微博原文本
 *
 *  @return WXLabel可以显示图片的文本格式
 */
- (NSString *)exChangedImageNameWithContent:(NSString *)content
{
    // 1.在文本中找到所有需要转换的字符串
    // 2.找到需要转换文本对应的图片
    // 3.拼接成需要转换的文本：呵呵.png -> <image url = '呵呵.png'>
    // 4.替换：[呵呵] -> <image url = '呵呵.png'>
    
    // 获取本地表情的配置信息
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    // 1.在文本中找到所有需要转换的字符串
    // 创建正则表达式
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceNames = [content componentsMatchedByRegex:regex];
    for (NSString *faceName in faceNames) {
        // 2.找到需要转换文本对应的图片
        // 使用谓词过滤找到对应表情的字典
        NSString *predicateString = [NSString stringWithFormat:@"self.chs like '%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *array = [emoticons filteredArrayUsingPredicate:predicate];
        // 如果array里面有一个值的时候说明搜索正确
        if (array.count == 1) {
            // 3.拼接成需要转换的文本：呵呵.png -> <image url = '呵呵.png'>
            // 获取图片的名字
            NSString *imageName = array[0][@"png"];
            NSString *imageHtml = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            // 4.替换：[呵呵] -> <image url = '呵呵.png'>
            content = [content stringByReplacingOccurrencesOfString:faceName withString:imageHtml];
        }
       
    }
    
    return content;
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"text:%@,userName:%@",self.text,self.userModel.screen_name];
}
@end

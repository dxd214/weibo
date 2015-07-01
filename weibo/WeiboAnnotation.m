//
//  WeiboAnnotation.m
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        if ([_weiboModel.geo isKindOfClass:[NSDictionary class]]) {
            NSArray *coordinates = _weiboModel.geo[@"coordinates"];
            // 获取经纬度
            double lat = [coordinates[0] doubleValue];
            double lon = [coordinates[1] doubleValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
}
@end

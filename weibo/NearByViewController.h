//
//  NearByViewController.h
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface NearByViewController : BaseViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
}
@property (nonatomic,strong) NSArray *dataList;
@end

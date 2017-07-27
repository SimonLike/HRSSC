//
//  HRMapView.h
//  Hrssc
//
//  Created by Simon on 2017/5/12.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HRMapBlock)(NSString *address);

@interface HRMapView : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKGeoCodeSearch* searcher;
@property (strong, nonatomic) NSString* mp_address;//反检索地址

@property (nonatomic) CLLocationCoordinate2D locationCoor;//反检索地址经纬


@property (copy, nonatomic)HRMapBlock hrBlock;
-(void)map_viewWillAppear;
-(void)map_viewWillDisappear;

-(void)setSearchAddress:(NSString *)address;


@end

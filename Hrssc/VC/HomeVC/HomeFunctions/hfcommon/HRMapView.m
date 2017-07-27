
//
//  HRMapView.m
//  Hrssc
//
//  Created by Simon on 2017/5/12.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMapView.h"

@implementation HRMapView

-(void)map_viewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.searcher.delegate = self;
}

-(void)map_viewWillDisappear {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.searcher.delegate = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.mapView.frame = CGRectMake(0, 0, self.width, self.height);

}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.scrollEnabled = YES;
    self.mapView.mapType = BMKUserTrackingModeFollowWithHeading;
//    self.mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    self.mapView.zoomLevel = 16;//地图显示比例
    self.mapView.rotateEnabled = NO; //设置是否可以旋转
    [self addSubview:self.mapView];
    
//    [self addCustomGestures];//添加自定义的手势

    self.searcher =[[BMKGeoCodeSearch alloc]init];
  
}

-(void)setSearchAddress:(NSString *)address{
    self.mp_address = address;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    //    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = address;
    BOOL flag = [self.searcher geoCode:geoCodeSearchOption];
    DLog(@"检索地址->%@",address);
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}


#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //    [alert show];
    //    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
    if (self.hrBlock) {
        self.hrBlock(self.mp_address);
    }
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        DLog(@"result---->%f-->%f",result.location.latitude,result.location.longitude);
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        coor.latitude = result.location.latitude;
        coor.longitude = result.location.longitude;
        self.locationCoor = coor;
        annotation.coordinate = coor;
//        annotation.title = @"这里";
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:coor animated:YES];

    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"icon_bdingwei"];
        return newAnnotationView;
    }
    return nil;
}
#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self addGestureRecognizer:doubleTap];
    
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
    NSLog(@"my handleSingleTap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    NSLog(@"my handleDoubleTap");
}

@end

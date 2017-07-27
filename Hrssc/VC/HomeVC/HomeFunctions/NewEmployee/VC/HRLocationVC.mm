
//
//  HRLocationVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/8.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRLocationVC.h"
#import "HRMapView.h"

@interface HRLocationVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet HRMapView *hrMapView;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;

@end

@implementation HRLocationVC


-(void)viewWillAppear:(BOOL)animated
{
    [self.hrMapView map_viewWillAppear];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.hrMapView map_viewWillDisappear];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"地址";
    self.adrLabel.text = self.adr;
    [self.hrMapView setSearchAddress:self.adr];
}
//导航   地图列表
- (IBAction)dh_click:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"百度地图",@"腾讯地图",@"高德地图",@"取消", nil];
    alert.tag = 9;
    [alert show];
}

#pragma mark -- alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DLog(@"buttonIndex-->%ld",(long)buttonIndex);
    if (alertView.tag == 9) {//地图列表
        if(buttonIndex == 0){//百度地图
            [self map:@"baidumap" AlertTag:10];
        }else if (buttonIndex == 1){//腾讯地图
            [self map:@"qqmap" AlertTag:11];
        }else if (buttonIndex == 2){//高德地图
            [self map:@"iosamap" AlertTag:12];
        }
    }else if (alertView.tag ==10){//百度地图下载
        if (buttonIndex == 0) {//立即安装
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/bai-du-de-tuhd/id553771681?mt=8"]];
        }
    }else if (alertView.tag ==11){//腾讯地图下载
        if (buttonIndex == 0) {//立即安装
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/nl/app/teng-xun-tu-ti-yan-jing-zhun/id481623196?mt=8"]];

        }
    }else if (alertView.tag ==12){//高德地图下载
        if (buttonIndex == 0) {//立即安装
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/gao-tu-zhuan-ye-shou-ji-tu/id461703208?mt=8"]];

        }
    }
}

-(void)map:(NSString *)schemes AlertTag:(NSInteger)alertTag{
    //地图的接入
    NSString*stringURL= [NSString stringWithFormat:@"%@://",schemes];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        CLLocationCoordinate2D coordinate = self.hrMapView.locationCoor;
       
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *urlScheme = @"iOSHRSSC";
        
        if ([schemes isEqualToString:@"baidumap"]) {//百度地图线路规划
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else if ([schemes isEqualToString:@"qqmap"]){//腾讯地图线路规划
             NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else if ([schemes isEqualToString:@"iosamap"]) {//高德地图线路规划
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您未安装此地图，是否立即前往APPStore安装！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即安装",@"稍后安装",nil];
        alert.tag = alertTag;
        [alert show];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

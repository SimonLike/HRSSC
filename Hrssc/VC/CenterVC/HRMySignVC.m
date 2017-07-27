//
//  HRMySignVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMySignVC.h"
#import "HRNotInfosView.h"
@interface HRMySignVC ()

@end

@implementation HRMySignVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的签名";
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [self setUpSign];
}

- (void)setUpSign
{
    if([self.signature isEqualToString:@""])
    {//没有签名链接
//        UIImageView* img = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        img.image = PNG_FROM_NAME(@"");
//        [self.view addSubview:img];
        HRNotInfosView *infosView = [HRNotInfosView initNotInfosView];
        infosView.frame = self.view.bounds;
        [self.view addSubview:infosView];

    }
    else
    {
        UIImageView* signImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_STATUS_NAVIGATION, SCREEN_WIDTH, 120)];
        signImg.backgroundColor = [UIColor whiteColor];
       
        [signImg sd_setImageWithURL:[NSURL URLWithString:[Utils readUser].signature]placeholderImage:DEFAULTIMG completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:.5 animations:^{
            } completion:^(BOOL finished) {
            }];
        }];
        
         [self.view addSubview:signImg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

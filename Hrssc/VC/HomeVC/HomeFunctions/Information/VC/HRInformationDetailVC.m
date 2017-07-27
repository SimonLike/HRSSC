

//
//  HRInformationDetailVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/4.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRInformationDetailVC.h"
#import "HRHomeInfoVO.h"

@interface HRInformationDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *haveView;
@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HRInformationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Net NewsById:[Utils readUser].token Nid:self.nid CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            HRNewsVO *obj = [HRNewsVO objectWithKeyValues:info[@"data"][@"news"]];
            if (obj) {
                self.titleLabel.text = obj.title;
                self.timeLabel.text = obj.create_time;
                [self.webView loadHTMLString:obj.content baseURL:nil];
            }else{
                self.noView.hidden = NO;
                self.haveView.hidden = YES;
            }
        }else{
            self.noView.hidden = NO;
            self.haveView.hidden = YES;
        }
    } FailBack:^(NSError *error) {
        self.noView.hidden = NO;
        self.haveView.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

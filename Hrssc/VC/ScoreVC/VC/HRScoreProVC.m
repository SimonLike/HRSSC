//
//  HRScoreProVC.m
//  Hrssc
//
//  Created by admin on 17/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreProVC.h"
#import "HRProDetialCell.h"
#import "HRScoreBuyVC.h"

#import "OrderDetialVO.h"

@interface HRScoreProVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIWebViewDelegate>
{
    UITableView* proTable;
    UIButton* backBtn;;
    SDCycleScrollView *cycleScrollView;
    UIView* bottowView;
    HRProDetialVO* currentPVO;
}
@property (nonatomic, copy)NSString *s_description;
@property (nonatomic, copy)OrderDetialVO *orderDetialObj;

@end

@implementation HRScoreProVC

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];

    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    [Utils creatBackItemNIL:self Selector:nil];
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 32, 32)];
    [backBtn setImage:PNG_FROM_NAME(@"back") forState:0];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
   
    proTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    proTable.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20-50);
    proTable.backgroundColor = [UIColor clearColor];
    proTable.delegate = self;
    proTable.dataSource = self;
    [self.view addSubview:proTable];
    
    if (self.pid) {//查询商品详情
        [self productDetial];
    }else{//订单详情
        [self orderDetial];
    }
    
}

- (void)orderDetial{
    [Net OrderDetial:[Utils readUser].token OrderId:self.orderId CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            DLog(@"info--->%@",info);
            _orderDetialObj = [OrderDetialVO objectWithKeyValues:info[@"data"][@"order"]];
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)productDetial
{
    [Net productDetial:[Utils readUser].token Pid:self.pid CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            currentPVO = [HRProDetialVO objectWithKeyValues:info[@"data"]];
            currentPVO.images = [NSMutableArray new];
            [currentPVO.images addObjectsFromArray:info[@"data"][@"iamges"]];
            self.s_description = info[@"data"][@"product"][@"description"];
            NSMutableArray* urlAry = [NSMutableArray new];
            
            for (NSDictionary* dic in currentPVO.images) {
                [urlAry addObject:[NSString stringWithFormat:@"%@/%@",PIC_HOST,dic[@"url"]]];
            }
            if(!cycleScrollView)
            {
                cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280) imageURLStringsGroup:urlAry];
                [cycleScrollView setPlaceholderImage:DEFAULTIMG];
                cycleScrollView.delegate = self;
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            }
            else
                cycleScrollView.imageURLStringsGroup = urlAry;
            [proTable reloadData];
            
            // 下面按钮状态
            [self creatBottowView];

        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)creatBottowView
{
    bottowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    if([currentPVO.product.status isEqualToString:@"1"])
    {
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:bottowView.bounds];
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"已下架";
        bottowView.backgroundColor = [UIColor lightGrayColor];
        [bottowView addSubview:tipLabel];
    }
    else
    {
        UIView* tLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
        tLine.backgroundColor = [UIColor lightGrayColor];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 3, 80, 44)];
        [btn setTitle:@"兑换" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.backgroundColor = [Utils colorWithHexString:@"1978CA"];
        [Utils cornerView:btn withRadius:5 borderWidth:0 borderColor:nil];
        [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        [bottowView addSubview:tLine];
        [bottowView addSubview:btn];
        bottowView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:bottowView];
}

- (void)buy
{
    HRScoreBuyVC* vc = [HRScoreBuyVC new];
    vc.currentVO = _currentVO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 280;
    else
        return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    if(section == 0)
    {
        vv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 280);
        [vv addSubview:cycleScrollView];
        [vv addSubview:backBtn];
    }
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 90;
    else
        return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        static NSString *cellIdentifier = @"HRProDetialCell";
        HRProDetialCell *cell = (HRProDetialCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [HRProDetialCell getInstanceWithNib];
        }
        else{
            //NSLog(@"FixMentCell");
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUI:currentPVO];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Key";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
        web.delegate = self;
        web.backgroundColor = [UIColor lightGrayColor];
        web.scalesPageToFit = YES;
        [web loadHTMLString:self.s_description baseURL:nil];
        DLog(@"currentPVO.product.description-->%@",self.s_description);
        [cell.contentView addSubview:web];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"---------开始加载--------");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    DLog(@"---------加载完成--------");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"---------加载失败--------");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

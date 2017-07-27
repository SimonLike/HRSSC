//
//  HRMsgDetialVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMsgDetialVC.h"

@interface HRMsgDetialVC ()<UITableViewDataSource,UITableViewDelegate>
{
    HRMsgVO* currentVO;
    UITableView* msgTable;
}
@end

@implementation HRMsgDetialVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [self setUpTable];
    [self getData];
}

- (void)setUpTable
{
    msgTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    msgTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -1);
    msgTable.backgroundColor = [UIColor whiteColor];
    msgTable.delegate = self;
    msgTable.dataSource = self;
    msgTable.scrollEnabled = NO;
    msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:msgTable];
}

- (void)getData
{
    [Net InfoDetial:[Utils readUser].token Mid:_mId CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            NSDictionary* dic = info[@"data"];
            NSDictionary* dic2 = dic[@"message"];
            currentVO = [HRMsgVO objectWithKeyValues:dic2];
            [msgTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return [self cellSize:currentVO.title];
            break;
        case 1:
            return 30;
        case 2:
            return tableView.height - 50 - [self cellSize:currentVO.title];
        default:
            return 30;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *cellIdentifier = @"Key";
    UITableViewCell *cell = [tableView   dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    CGFloat height;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0)];
    titleLabel.numberOfLines = 100000;
    switch (row) {
        case 0:
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textColor = [Utils colorWithHexString:@"353535"];
            height = [self cellSize:currentVO.title];
            titleLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, height);
            titleLabel.text = currentVO.title;
            
            break;
        case 1:
            titleLabel.font = [UIFont systemFontOfSize:12.0];
            titleLabel.textColor = [Utils colorWithHexString:@"888888"];
            height = [self cellSize:currentVO.create_time];
            titleLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 30);
            titleLabel.text = currentVO.create_time;
            break;
        case 2:{
            height = [self cellSize:currentVO.content];
            UIWebView *textv = [[UIWebView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, tableView.height - 50 - [self cellSize:currentVO.title])];
            [textv loadHTMLString:currentVO.content baseURL:nil];
            [cell.contentView addSubview:textv];

        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:titleLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)cellSize:(NSString*)str;
{
    CGFloat height;
    height = [Utils heightOfText:str theWidth:SCREEN_WIDTH-30 theFont:[UIFont systemFontOfSize:14]];
    return height+16;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

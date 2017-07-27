//
//  HRSettingVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSettingVC.h"
#import "HRAboutUsVC.h"
#import "AppDelegate.h"

@interface HRSettingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* conTable;
    UILabel* cacheLabel;
    MBProgressHUD* p_progressHUD;
    UIButton* commitBtn;
}
@end

@implementation HRSettingVC

- (void)setUI
{
    self.title = @"设置";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-125-40, 0, 125, 56)];
    cacheLabel.textAlignment = NSTextAlignmentRight;
    cacheLabel.textColor = [UIColor lightGrayColor];
    cacheLabel.font = [UIFont systemFontOfSize:12];
    commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-100, SCREEN_WIDTH-40, 50)];
    [commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundColor:[Utils colorWithHexString:@"1978CA"]];
    [Utils cornerView:commitBtn withRadius:5 borderWidth:0 borderColor:nil];
    [commitBtn setTitle:@"退出登录" forState:0];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self setUpTable];
    [self.view addSubview:commitBtn];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUpTable
{
    conTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    conTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    conTable.backgroundColor = [UIColor clearColor];
    conTable.delegate = self;
    conTable.dataSource = self;
    [self.view addSubview:conTable];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Key";
    UITableViewCell *cell = [tableView   dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 56)];
    titleLabel.textColor = [Utils colorWithHexString:@"353535"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    if(indexPath.row == 0)
    {
        titleLabel.text = @"清除缓存";
        cacheLabel.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] checkTmpSize]+[self readCacheSize]];
        [cell.contentView addSubview:cacheLabel];
    }
    else
        titleLabel.text = @"关于我们";
    [cell.contentView addSubview:titleLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self clearCash:nil];
    }
    else
    {
        HRAboutUsVC* vc = [HRAboutUsVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)clearCash:(id)sender
{
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self clearFile];
    }];
    
}

- (IBAction)commit:(id)sender
{
    [Net LoginOut:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [[XQTipInfoView getInstanceWithNib] appear:@"已退出"];
            [(AppDelegate*)MyAppDelegate switchLoginStatue:NO];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

//1. 获取缓存文件的大小
-(float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}

// 遍历文件夹获得文件夹大小，返回多少 M
- (float) folderSizeAtPath:(NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
    
}

// 计算 单个文件的大小
- (long long) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

//2. 清除缓存
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
          
        }
    }
    [SVProgressHUD dismiss];

    [[XQTipInfoView getInstanceWithNib] appear:@"清理完毕"];
    //读取缓存大小
//    float cacheSize = [self readCacheSize] *1024;
//    cacheLabel.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
    cacheLabel.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] checkTmpSize] + [self readCacheSize]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  HRUserInfoVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRUserInfoVC.h"

@interface HRUserInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView* img;
    NSString* urlIcon;
    UIImage* defaultImg;
    UITableView* userTable;
}
@end

@implementation HRUserInfoVC

- (void)setUI
{
    self.title = @"个人资料";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50-14, 15, 50, 50)];
    [Utils cornerView:img withRadius:25 borderWidth:0 borderColor:nil];
    defaultImg = PNG_FROM_NAME(@"defaulthead_small.png");
    [self setUpTable];
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
    userTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    userTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    userTable.backgroundColor = [UIColor clearColor];
    userTable.delegate = self;
    userTable.dataSource = self;
    [self.view addSubview:userTable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return 12;
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
            return 80;
            break;
        default:
            return 56;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    HRUserInfoVO* uVO = _currentVO;
    static NSString *cellIdentifier = @"Key";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 56)];
    UILabel* detialLabel;
    
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textColor = [Utils colorWithHexString:@"535353"];
    detialLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-14-175, 0, 175, 56)];
    detialLabel.textAlignment = NSTextAlignmentRight;
    detialLabel.textColor = [Utils colorWithHexString:@"333333"];
    detialLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (row) {
        case 0:
        {
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,uVO.head]] placeholderImage:defaultImg];
            defaultImg = img.image;
            titleLabel.text = @"头像";
            titleLabel.frame = CGRectMake(15, 0, 100, 80);
            [cell.contentView addSubview:img];
        }
            break;
        case 1:
            titleLabel.text = @"姓名";
            detialLabel.text = uVO.name;
            break;
        case 2:
            titleLabel.text = @"工号";
            detialLabel.text = uVO.uin;
            break;
        case 3:
            titleLabel.text = @"手机号";
            detialLabel.text = uVO.phone;
            break;
        case 4:
            titleLabel.text = @"职级";
            detialLabel.text = uVO.level;
            break;
        case 5:
            titleLabel.text = @"户口所在地";
            detialLabel.text = uVO.hukou_prov;
            break;
        case 6:
            titleLabel.text = @"紧急联系人电话";
            detialLabel.text = uVO.emergency_phone;
            break;
        case 7:
            titleLabel.text = @"邮箱";
            detialLabel.text = uVO.email;
            break;
        case 8:
            titleLabel.text = @"性别";
            detialLabel.text = [uVO.sex isEqualToString:@"0"]?@"男":@"女";
            break;
        case 9:
            titleLabel.text = @"身份证";
            detialLabel.text = uVO.id_card;
            break;
        case 10:
            titleLabel.text = @"出生日期";
            detialLabel.text = uVO.birthday;
            break;
        case 11:
            titleLabel.text = @"民族";
            detialLabel.text = uVO.minority;
            break;
        default:
            break;
    }
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:detialLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

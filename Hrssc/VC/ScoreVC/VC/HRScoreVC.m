//
//  HRScoreVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreVC.h"
#import "HRScoreProVC.h"
#import "HRScoreCell.h"
#import "HRScoreRecordVC.h"
#import "HRMsgCenterVC.h"
#import "HRCommonWebVC.h"
#import "HRUserInfoVO.h"

@interface HRScoreVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView* scoreCollectionView;
    UIButton* infomationBtn;
    UIImageView* tipImg;
    SDCycleScrollView *cycleScrollView;
    int Page;
    int PageSize;
    NSMutableArray* productAry;
    UIView* headerView;
    UIImageView* headerImg;
    UIView* scoreView;
    UILabel* scoreLabel;
}
@end

@implementation HRScoreVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    [Net UserInfo:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            scoreLabel.text = [NSString stringWithFormat:@"%@",info[@"data"][@"user"][@"amount"]];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分商城";
    
    self.cityView.cityLabel.hidden = YES;
    self.cityView.upIma.hidden = YES;
    [self.cityView.leftButton setTitle:@"积分规则" forState:UIControlStateNormal];
    
    productAry = [NSMutableArray new];
    Page = 1;
    PageSize = 10;
    [self setUpHeaderView];
    [self setUpCollect];
    
    
    //获取banner
    [Net GetBanner:[Utils readUser].token Location:1 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            HRBannerVO *obj = [HRBannerVO objectWithKeyValues:info[@"data"][@"banner"]];
            [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.image]] placeholderImage:nil];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    [self getData];
}

//积分规则
- (void)leftAction
{
    HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
    vc.link = @"http://hrsscadmin.trydo.online/hrsscSystemConfig/toIntegralRulePage";
    vc.title = @"积分规则";
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
}

- (void)infoMsg
{
    HRMsgCenterVC* vc = [HRMsgCenterVC new];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)recode
{
    HRScoreRecordVC* vc = [HRScoreRecordVC new];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)setUpHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 218)];
    headerView.backgroundColor = [UIColor clearColor];
    
    headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    [headerImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DEFAULTIMG];
    headerImg.backgroundColor = [UIColor yellowColor];
    [headerView addSubview:headerImg];
    
    scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 168, SCREEN_WIDTH, 50)];
    scoreView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recode)];
    [scoreView addGestureRecognizer:tap];
    
    UIView* tLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    tLine.backgroundColor = [Utils colorWithHexString:@"eeeeee"];
    UIView* bLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, .5)];
    bLine.backgroundColor = [Utils colorWithHexString:@"eeeeee"];
    [scoreView addSubview:tLine];
    [scoreView addSubview:bLine];
    UIImageView* iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 17, 14, 16)];
    iconImg.image = PNG_FROM_NAME(@"icon_jifen");
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 70, 50)];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"当前积分";
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 0, 200, 50)];
    scoreLabel.textColor = [Utils colorWithHexString:@"1978CA"];
    scoreLabel.text = [Utils readUser].amount;
    UILabel* tipLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 70, 50)];
    tipLable.textColor = [UIColor lightGrayColor];
    tipLable.textAlignment = NSTextAlignmentRight;
    tipLable.font = [UIFont systemFontOfSize:13];
    tipLable.text = @"兑换记录";
    UIImageView* arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 20, 5, 10)];
    arrowImg.image = PNG_FROM_NAME(@"icon_xianghou");
    [scoreView addSubview:iconImg];
    [scoreView addSubview:title];
    [scoreView addSubview:scoreLabel];
    [scoreView addSubview:tipLable];
    [scoreView addSubview:arrowImg];
    [headerView addSubview:scoreView];
}

- (void)setUpCollect
{
    UICollectionViewFlowLayout* layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 218);
    scoreCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) collectionViewLayout:layOut];
    [scoreCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhead"];
    
    scoreCollectionView.backgroundColor = [UIColor clearColor];
    scoreCollectionView.dataSource = self;
    scoreCollectionView.delegate = self;
    [self.view addSubview:scoreCollectionView];
    
}

- (void)getData
{
    [Net ScoreProducts:[Utils readUser].token Page:Page Rows:PageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            NSArray* proAry = [HRScoreProductVO objectArrayWithKeyValuesArray:info[@"data"][@"products"]];
            [productAry addObjectsFromArray:proAry];
            [scoreCollectionView reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

#pragma mark - collection view data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return productAry.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

//每个UICollectionView展示的内容

- (CGFloat)collectionView:(UICollectionView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 218;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhead" forIndexPath:indexPath];
        
        [reusableview addSubview:headerView];
    }
    else
    {
        
    }
    return reusableview;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HRScoreCell";
    [collectionView registerNib:[UINib nibWithNibName:@"HRScoreCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    HRScoreCell *cell  = (HRScoreCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [HRScoreCell getInstanceWithNib];
    }
    
    [cell setUI:productAry[indexPath.row]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-24)/2, 232);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 8, 8);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRScoreProVC* vc = [HRScoreProVC new];
    vc.currentVO = productAry[indexPath.row];
    vc.pid = [[(HRScoreProductVO *)productAry[indexPath.row] id] intValue];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

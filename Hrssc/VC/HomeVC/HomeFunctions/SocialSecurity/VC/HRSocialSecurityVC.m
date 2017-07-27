
//
//  HRSocialSecurityVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSocialSecurityVC.h"
#import "HRSocialSecurityCell.h"
#import "HRDealThatDeatilVC.h"
#import "HRSocialPaymentVC.h"
#import "HRCategory2ListObj.h"

@interface HRSocialSecurityVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ss_collection;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (nonatomic, strong) NSArray *scoialArr;
@property (nonatomic, strong) NSArray *scoialImaArr;
@end

@implementation HRSocialSecurityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ss_collection registerNib:[UINib nibWithNibName:@"HRSocialSecurityCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HRSocialSecurityCell"];
    
    //获取banner
    [Net GetBanner:[Utils readUser].token Location:2 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            HRBannerVO *obj = [HRBannerVO objectWithKeyValues:info[@"data"][@"banner"]];
            [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.image]] placeholderImage:nil];
        }
    } FailBack:^(NSError *error) {
        
    }];
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);

            self.scoialArr = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            //    初始化数据
            [self initData];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    self.scoialImaArr = [NSMutableArray arrayWithObjects:@"icon_sbjjcx",@"icon_sbbg",@"icon_sbyb",@"icon_sbzy",@"icon_sbzyc",@"icon_ylba",@"icon_sbbx",@"icon_sbcbzm",  nil];
    [self.ss_collection reloadData];
}

#pragma --mark UICollectionViewDelegate UICollectionViewDatasoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.scoialArr.count;
//    int place = 0;
//
//    if (_datas.count%3 == 1 ) {
//
//        place = 2;
//    }else if (_datas.count%3 == 2){
//
//        place = 1;
//    }
//    return _datas.count + place;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * CellIdentifier = @"HRSocialSecurityCell";
    HRSocialSecurityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    HRCategory2ListObj *obj = self.scoialArr[indexPath.row];
    if (indexPath.row<self.scoialImaArr.count) {
        cell.image.image = [UIImage imageNamed:self.scoialImaArr[indexPath.row]];
    }
    cell.label.text = obj.name;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(0, 0);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"被选中了");
    if (indexPath.row == 0) {
        HRSocialPaymentVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSocialPayment"];
        vc.cid = 2;
        vc.cid2 = [(HRCategory2ListObj *)self.scoialArr[0] id];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HRDealThatDeatilVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThatDeatil"];
        vc.title = [self.scoialArr[indexPath.row] name];
        vc.proveName = [self.scoialArr[indexPath.row] name];
        vc.cid2 = [(HRCategory2ListObj *)self.scoialArr[indexPath.row] id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
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

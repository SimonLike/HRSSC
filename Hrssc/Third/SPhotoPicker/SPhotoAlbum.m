//
//  SPhotoAlbum.m
//  SPhotoPicker
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 S. All rights reserved.
//
#define BTMHeight 50
#import "SPhotoAlbum.h"

@interface SPhotoAlbum ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView* photoCollection;
    NSMutableArray* selectImgAry;
    NSMutableArray* originalAry;
    NSMutableArray* albumAry;
    BOOL isOriginal;
    UIButton* originalBtn;
    UILabel* numLabel;
    UIButton* sendBtn;
}
@property (nonatomic, strong) UIView* bottowView;
@end

@implementation SPhotoAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn setTitleColor:[UIColor blackColor] forState:0];
    [backBtn setTitle:@"返回" forState:0];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    UICollectionViewFlowLayout* layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.headerReferenceSize = CGSizeMake(0, 0);
    photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-BTMHeight) collectionViewLayout:layOut];
    photoCollection.backgroundColor = [UIColor whiteColor];
    photoCollection.dataSource = self;
    photoCollection.delegate = self;
    [self.view addSubview:photoCollection];
    albumAry = [[NSMutableArray alloc] init];
    originalAry = [[NSMutableArray alloc] init];
    selectImgAry = [[NSMutableArray alloc] init];
    isOriginal = NO;
    [self setUpBottowView];
    [self getALAssetData];
}

- (IBAction)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getALAssetData
{
    [_alassetGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            ALAssetModel* alassetModel = [[ALAssetModel alloc] init];
            alassetModel.isSelect = NO;
            alassetModel.alasset = result;
            [albumAry addObject:alassetModel];
        } else {
            [photoCollection reloadData];
        }
    }];
}

- (void)setUpBottowView
{
    _bottowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BTMHeight, SCREEN_WIDTH, BTMHeight)];
    _bottowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottowView];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bottowView addSubview:lineView];
    originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
    [originalBtn setImage:unselectIMG forState:UIControlStateNormal];
    [originalBtn setImage:selectIMG forState:UIControlStateSelected];
    originalBtn.selected = NO;
    [originalBtn addTarget:self action:@selector(originalPhotoChose:) forControlEvents:UIControlEventTouchUpInside];
    [originalBtn setTitle:@"原图" forState:0];
    [originalBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:0];
    originalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bottowView addSubview:originalBtn];
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 40 - 8 - 16 - 4, 17, 16, 16)];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    numLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [_bottowView addSubview:numLabel];
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 8, 10, 40, 30)];
    [sendBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:0];
    [sendBtn setTitle:@"完成" forState:0];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn addTarget:self action:@selector(finishSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_bottowView addSubview:sendBtn];
    sendBtn.enabled = NO;
    originalBtn.enabled = NO;
    numLabel.hidden = YES;
    [self cornerView:numLabel withRadius:8 borderWidth:0 borderColor:nil];
}

- (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor{
    if (aR>0.) {
        aView.layer.cornerRadius = aR;
    }
    if (aB>0.) {
        aView.layer.borderWidth = aB;
        aView.layer.borderColor = aColor.CGColor;//
    }
    aView.clipsToBounds = YES;
}

- (IBAction)originalPhotoChose:(id)sender
{
    UIButton* oriBtn = sender;
    oriBtn.selected = !oriBtn.selected;
    isOriginal = oriBtn.selected;
}

- (IBAction)finishSelect:(id)sender
{
    NSMutableArray* urlAry = [[NSMutableArray alloc] init];
    NSMutableArray* photoAry = [[NSMutableArray alloc] init];
    for (ALAssetModel* aModel in selectImgAry) {
        UIImage* photoImage;
        ALAsset* aset = aModel.alasset;
        if(isOriginal)
        {
            ALAssetRepresentation *representation = [aset defaultRepresentation];
            photoImage = [UIImage imageWithCGImage:representation.fullScreenImage];
            [photoAry addObject:photoImage];
        }
        else
        {
            photoImage = [UIImage imageWithCGImage:aset.aspectRatioThumbnail];
            [photoAry addObject:photoImage];
        }
        [urlAry addObject:aset.defaultRepresentation.url];
        NSLog(@"%@",aset.defaultRepresentation.url);
    }
    if(_delegate&&[_delegate respondsToSelector:@selector(SPhotoAlbum:PhotoAry:IsOriginal:)])
        [_delegate SPhotoAlbum:urlAry PhotoAry:photoAry IsOriginal:isOriginal];
    //这里回调，完成选择
}

#pragma mark - collection view data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return albumAry.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

//每个UICollectionView展示的内容

- (CGFloat)collectionView:(UICollectionView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        
    }
    else
    {
        
    }
    return reusableview;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SPhotoAlbumCell";
    [collectionView registerNib:[UINib nibWithNibName:@"SPhotoAlbumCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    SPhotoAlbumCell *cell  = (SPhotoAlbumCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [SPhotoAlbumCell getInstanceWithNib];
    }
    [cell setUI:albumAry[indexPath.row]];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-8)/4, (SCREEN_WIDTH-8)/4);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetModel* model = albumAry[indexPath.row];
    SPhotoAlbumCell *cell = (SPhotoAlbumCell*)[photoCollection cellForItemAtIndexPath:indexPath];
    if(model.isSelect)
    {
        model.isSelect = NO;
        [selectImgAry removeObject:model];
        if(selectImgAry.count == 0)
        {
            sendBtn.enabled = NO;
            originalBtn.enabled = NO;
            numLabel.hidden = YES;
            originalBtn.selected = NO;
            isOriginal = originalBtn.selected;
            [originalBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:0];
            [sendBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:0];
        }
    }
    else
    {
        if(selectImgAry.count >= _photoNum)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多可选择%i张图片",_photoNum] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        model.isSelect = YES;
        [selectImgAry addObject:model];
        sendBtn.enabled = YES;
        originalBtn.enabled = YES;
        numLabel.hidden = NO;
        [originalBtn setTitleColor:[UIColor blackColor] forState:0];
        [sendBtn setTitleColor:[UIColor blackColor] forState:0];
    }
    numLabel.text = [NSString stringWithFormat:@"%li",selectImgAry.count];
    numLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:.2 animations:^{
        numLabel.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        numLabel.transform = CGAffineTransformIdentity;
    }];
    [cell setSelect:model.isSelect];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

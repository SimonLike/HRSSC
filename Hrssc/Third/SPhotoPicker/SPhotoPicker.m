//
//  SPhotoPicker.m
//  Insurance
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 BB. All rights reserved.
//
#import "SPhotoPicker.h"
@interface SPhotoPicker ()<UITableViewDelegate,UITableViewDataSource,SPhotoAlbumDelegate>
{
    NSMutableArray* _albumsArray;
    UITableView* photoTable;
}
@property (nonatomic, strong) ALAssetsLibrary* assetsLibrary;
@end

@implementation SPhotoPicker



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor blackColor] forState:0];
    [rightBtn setTitle:@"取消" forState:0];
    [rightBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
    }
    else
    {
        _albumsArray = [[NSMutableArray alloc] init];
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        [self setUpTable];
        [self getPhoto];
    }
    
}

- (IBAction)clickBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)setUpTable
{
    photoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    photoTable.delegate = self;
    photoTable.dataSource = self;
    photoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:photoTable];
}

- (void)getPhoto
{
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0)
            {
                // 把相册储存到数组中，方便后面展示相册时使用
                [_albumsArray addObject:group];
            }
            else{
                NSLog(@"相册名字%@\n",[group valueForProperty:ALAssetsGroupPropertyName]);
            }
        } else {
            if ([_albumsArray count] > 0) {
                [photoTable reloadData];
                // 把所有的相册储存完毕，可以展示相册列表
            } else {
                // 没有任何有资源的相册，输出提示
                NSLog(@"没有任何相册\n");
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    ALAssetsGroup* group = _albumsArray[row];
    UIImage *posterImg = [self getFirstAlbumPosterImg:group];
    static NSString *cellIdentifier = @"Key";
    UITableViewCell *cell = [tableView   dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = posterImg;
    imageView.clipsToBounds = YES;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, 100)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:titleLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup* group = _albumsArray[indexPath.row];
    SPhotoAlbum* album = [[SPhotoAlbum alloc] init];
    album.alassetGroup = group;
    album.photoNum = _photoNum;
    album.delegate = self;
    album.title = [group valueForProperty:ALAssetsGroupPropertyName];
    [self.navigationController pushViewController:album animated:YES];
    //加入选择事件
}

- (UIImage*)getFirstAlbumPosterImg:(ALAssetsGroup*)group
{
    __block UIImage *posterImg;
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
        
        __block BOOL foundThePhoto = NO;
        if (foundThePhoto)
            *stop = YES;
        // ALAsset的类型
        NSString *assetType = [result valueForProperty:ALAssetPropertyType];
        if ([assetType isEqualToString:ALAssetTypePhoto])
        {
            foundThePhoto = YES;
            *stop = YES;
            ALAssetRepresentation *assetRepresentation =[result defaultRepresentation];
            CGFloat imageScale = [assetRepresentation scale];
            UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
            CGImageRef imageReference = [assetRepresentation fullResolutionImage];
            // 对找到的图片进行操作
            UIImage *image =[[UIImage alloc] initWithCGImage:imageReference scale:imageScale orientation:imageOrientation];
            if (image != nil){
                posterImg = image;
            }
        }
    }];
    return posterImg;
}

- (void)SPhotoAlbum:(NSMutableArray *)urlArray PhotoAry:(NSMutableArray *)photoAry IsOriginal:(BOOL)IsOriginal
{
    if(_delegate&&[_delegate respondsToSelector:@selector(SPhotoPicker:PhotoAry:IsOriginal:)])
        [_delegate SPhotoPicker:urlArray PhotoAry:photoAry IsOriginal:IsOriginal];
    [self clickBack:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

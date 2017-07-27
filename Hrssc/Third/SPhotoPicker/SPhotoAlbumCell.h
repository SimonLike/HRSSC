//
//  SPhotoAlbumCell.h
//  SPhotoPicker
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 S. All rights reserved.
//
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define selectIMG [UIImage imageNamed:@"select.png"]
#define unselectIMG [UIImage imageNamed:@"unselect.png"]

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetModel : NSObject
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) ALAsset* alasset;
@end

@interface SPhotoAlbumCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView* photo;
@property (nonatomic, strong) IBOutlet UIImageView* photoSelect;
+ (SPhotoAlbumCell*)getInstanceWithNib;
- (void)setUI:(ALAssetModel*)alassetModel;
- (void)setSelect:(BOOL)isSelect;
@end

//
//  SPhotoAlbumCell.m
//  SPhotoPicker
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 S. All rights reserved.
//

#import "SPhotoAlbumCell.h"

@implementation ALAssetModel

@end

@implementation SPhotoAlbumCell

- (void)awakeFromNib {
    // Initialization code
}

+ (SPhotoAlbumCell*)getInstanceWithNib{
    SPhotoAlbumCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"SPhotoAlbumCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[SPhotoAlbumCell class]]){
            cell = (SPhotoAlbumCell *)obj;
            break;
        }
    }
    return cell;
}

- (void)setUI:(ALAssetModel*)alassetModel
{
    ALAsset* aset = alassetModel.alasset;
    BOOL isSelect = alassetModel.isSelect;
    if(isSelect)
        _photoSelect.image = selectIMG;
    else
        _photoSelect.image = unselectIMG;
    //ALAssetRepresentation *representation = [aset defaultRepresentation];
    // 获取资源图片的 fullScreenImage
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIImage *contentImage = [UIImage imageWithCGImage:aset.aspectRatioThumbnail];
        // 对找到的图片进行操作
        if (contentImage != nil){
            _photo.image = contentImage;
        } else {
            
        }
    });
}

- (void)setSelect:(BOOL)isSelect
{
    if(isSelect)
        _photoSelect.image = selectIMG;
    else
        _photoSelect.image = unselectIMG;
}

@end

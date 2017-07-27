//
//  SPhotoAlbum.h
//  SPhotoPicker
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 S. All rights reserved.
//


#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>
#import "SPhotoAlbumCell.h"

@protocol SPhotoAlbumDelegate <NSObject>

- (void)SPhotoAlbum:(NSMutableArray*)urlArray PhotoAry:(NSMutableArray*)photoAry IsOriginal:(BOOL)IsOriginal;

@end

@interface SPhotoAlbum : UIViewController
@property (nonatomic, strong) ALAssetsGroup* alassetGroup;
@property (nonatomic, strong) id<SPhotoAlbumDelegate>delegate;
@property (nonatomic, assign) int photoNum;
@end

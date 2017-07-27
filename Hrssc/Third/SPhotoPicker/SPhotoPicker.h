//
//  SPhotoPicker.h
//  Insurance
//
//  Created by S on 16/8/17.
//  Copyright © 2016年 BB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPhotoAlbum.h"

@protocol SPhotoPickerDelegate <NSObject>

- (void)SPhotoPicker:(NSMutableArray*)urlArray PhotoAry:(NSMutableArray*)photoAry IsOriginal:(BOOL)IsOriginal;

@end

@interface SPhotoPicker : UIViewController
@property (nonatomic, strong) id<SPhotoPickerDelegate>delegate;
@property (nonatomic, assign) int photoNum;
@end

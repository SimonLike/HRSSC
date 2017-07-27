//
//  HRPicCollectionView.h
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加相册照片
typedef void(^AddPicBlock)();
//删除照片
typedef void(^DelPicBlock)(NSInteger tag);

@interface HRPicCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSArray *picspathArr;
@property (nonatomic, strong)UICollectionView *pic_collection;

@property (nonatomic, strong)AddPicBlock addPicBlock;
@property (nonatomic, strong)DelPicBlock delPicBlock;

@property (nonatomic) int picTypeTnt; // 1,代表显示图片
@end

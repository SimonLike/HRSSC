//
//  LRUserShareView.h
//  LRVideo
//
//  Created by S on 16/5/31.
//  Copyright © 2016年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LRUserShareViewDelegate <NSObject>

- (void)shareType:(NSInteger)type;

@end

@interface LRUserShareView : UIView
@property (nonatomic, strong) id<LRUserShareViewDelegate>delegate;
+ (LRUserShareView*)getInstanceWithNib;
- (void)appear:(UIView*)hostView;
@end

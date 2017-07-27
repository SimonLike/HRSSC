//
//  MXCheckBigImageViewController.m
//  mxapp
//
//  Created by zhou on 16/6/6.
//  Copyright © 2016年 ksl. All rights reserved.
//

#import "MXCheckBigImageViewController.h"
#define zoomScale_flt 3.0
#define wt [UIScreen mainScreen].bounds.size.width / 320
#define ht [UIScreen mainScreen].bounds.size.height / 568
@interface MXCheckBigImageViewController ()<UIScrollViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImage *saveImage;

@property(nonatomic, strong)NSMutableArray *imgsArray;
@property(nonatomic, assign)NSInteger imgIndex;
@property(nonatomic, assign)NSInteger scrollIndex;
@property(nonatomic, strong)UIScrollView *scroll;
@property(nonatomic, strong)UILabel *indexLbl;
@property (nonatomic, strong)UITapGestureRecognizer *tap;

@end

@implementation MXCheckBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _imgsArray = _imageArray;
    _imgIndex = _imageTag;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    _tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tap];
    [self show];
}

- (void)changeScale:(UITapGestureRecognizer*)sender{
    CGFloat size = ((UIScrollView*)sender.view).zoomScale;
    if (size < zoomScale_flt) {
        [((UIScrollView*)sender.view) setZoomScale:zoomScale_flt animated:YES];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [((UIScrollView*)sender.view) setZoomScale:1 animated:NO];
            [self scrollViewDidScroll:(UIScrollView*)sender.view];
        }];
    }
}

- (void)dismiss:(UITapGestureRecognizer*)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)show {
    _scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    CGSize contentSize;
    /*保证最多同时加载5张图片*/
    NSInteger max = _imgsArray.count <= 5 ? _imgsArray.count : 5;
    contentSize = CGSizeMake(self.view.frame.size.width * max, self.view.frame.size.height);
    /*计算起始位置和当前滚动位置*/
    NSInteger startIndex = _imgIndex;
    
    if (_imgsArray.count <= 5 || _imgIndex < 3) {
        startIndex = 0;
        _scrollIndex = _imgIndex;
    } else if (_imgIndex < _imgsArray.count - 3) {
        startIndex = _imgIndex - 2;
        _scrollIndex = 2;
    } else {
        startIndex = _imgIndex - (4-(_imgsArray.count-_imgIndex-1));
        _scrollIndex = 4-(_imgsArray.count-1-_imgIndex);
    }

    /*循环加载图片*/
    for (int i = 0; i < max; i++) {
        UIScrollView *miniScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(i*_scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height)];
        miniScroll.delegate = self;
        miniScroll.minimumZoomScale = 1.0;
        miniScroll.maximumZoomScale = zoomScale_flt;
        UITapGestureRecognizer *twoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScale:)];
        twoTaps.numberOfTapsRequired = 2;
        /*长按保存图片*/
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageClick:)];
        longPress.minimumPressDuration = 0.5;
        
        [_tap requireGestureRecognizerToFail:twoTaps];
        [miniScroll addGestureRecognizer:twoTaps];
        [miniScroll addGestureRecognizer:longPress];
        [_scroll addSubview:miniScroll];
        
        UIImageView *eachImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width*366/536)/2, self.view.frame.size.width, self.view.frame.size.width*366/536)];
        eachImgView.backgroundColor = [UIColor whiteColor];
        eachImgView.userInteractionEnabled = YES;
        eachImgView.contentMode = UIViewContentModeScaleAspectFill;
        if ([_imgsArray[startIndex] isKindOfClass:[NSString class]]) {
            [eachImgView sd_setImageWithURL:[NSURL URLWithString:[PIC_HOST stringByAppendingString:_imgsArray[startIndex++]]] placeholderImage:[UIImage imageNamed:@"defaultIMG"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    return ;
                }
                if (image.size.width/image.size.height > self.view.frame.size.width/self.view.frame.size.height) {
                    eachImgView.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width/image.size.width*image.size.height)/2, self.view.frame.size.width, self.view.frame.size.width/image.size.width*image.size.height);
                } else {
                    eachImgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/image.size.width*image.size.height);
                }
            }];
        }else{
            eachImgView.image = _imgsArray[startIndex++];
        }
        
        [miniScroll addSubview:eachImgView];
    }
    _scroll.contentSize = contentSize;
    _scroll.contentOffset = CGPointMake(_scrollIndex*self.view.frame.size.width, 0);
    _scroll.delegate = self;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    [self.view addSubview:_scroll];
    
    _indexLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40*ht, self.view.frame.size.width, 23*ht)];
    _indexLbl.textColor = [UIColor whiteColor];
    _indexLbl.textAlignment = 1;
    _indexLbl.text = [NSString stringWithFormat:@"%ld / %ld",_imgIndex+1,_imgsArray.count];
    [self.view addSubview:_indexLbl];
}

-(void)saveImageClick:(id)sender
{
    UILongPressGestureRecognizer *longPress = sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *saveSheet = [[UIActionSheet alloc]initWithTitle:@"将图片保存到本地相册?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [saveSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveToAlbum];
    }
}

- (void)saveToAlbum {
    UIScrollView *scroll = _scroll.subviews[_scrollIndex];
    UIImageView *imgView = scroll.subviews[0];
    UIImageWriteToSavedPhotosAlbum(imgView.image, nil, nil, nil);
    [self showToast:@"已保存到本地相册"];
}

- (void)showToast:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scroll]) {
        float offset = scrollView.contentOffset.x - scrollView.frame.size.width * _scrollIndex;
        if (fabs(offset) >= scrollView.frame.size.width) {
            if (offset >= scrollView.frame.size.width) {//向右
                _imgIndex = _imgIndex + 1;
            } else if (offset <= -scrollView.frame.size.width) {//向左
                _imgIndex = _imgIndex - 1;
            }
            /*计算起始位置和当前滚动位置*/
            NSInteger startIndex = _imgIndex;
            
            if (_imgsArray.count <= 5 || _imgIndex < 3) {
                startIndex = 0;
                _scrollIndex = _imgIndex;
            } else if (_imgIndex < _imgsArray.count - 3) {
                startIndex = _imgIndex - 2;
                _scrollIndex = 2;
            } else {
                startIndex = _imgIndex - (4-(_imgsArray.count-_imgIndex-1));
                _scrollIndex = 4-(_imgsArray.count-1-_imgIndex);
            }
            for (UIView *view in scrollView.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *miniScroll = (UIScrollView*)view;
                    miniScroll.zoomScale = 1.0;
                    UIImageView *eachImgView = miniScroll.subviews[0];
                    eachImgView.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width*366/536)/2, self.view.frame.size.width, self.view.frame.size.width*366/536);
                    if ([_imgsArray[startIndex] isKindOfClass:[NSString class]]) {
                        [eachImgView sd_setImageWithURL:[NSURL URLWithString:[PIC_HOST stringByAppendingString:_imgsArray[startIndex++]]] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image == nil) {
                                return ;
                            }
                            if (image.size.width/image.size.height > self.view.frame.size.width/self.view.frame.size.height) {
                                eachImgView.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width/image.size.width*image.size.height)/2, self.view.frame.size.width, self.view.frame.size.width/image.size.width*image.size.height);
                            } else {
                                eachImgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/image.size.width*image.size.height);
                            }
                        }];}else{
                            eachImgView.image = _imgsArray[startIndex++];
                        }
                }
            }
            _scroll.contentOffset = CGPointMake(_scrollIndex*self.view.frame.size.width, 0);
            _indexLbl.text = [NSString stringWithFormat:@"%ld / %ld",_imgIndex+1,_imgsArray.count];
        }
    } else {
        //缩放后上下居中
        UIImageView *imgView = scrollView.subviews[0];
        if (imgView.frame.size.height < self.view.frame.size.height) {
            imgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.bounds.size.height/2);
        }else{
            imgView.frame = CGRectMake(imgView.frame.origin.x, 0, imgView.frame.size.width, imgView.frame.size.height);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  HRDealThatDeatilVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDealThatDeatilVC.h"
#import "HRWayModelVC.h"
#import "TemplatesObj.h"
#import "HRInputVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HRLanguageAlert.h"
#import "PicCollectionViewCell.h"
#import "SGImagePickerController.h"
#import "HRSuccessfulVC.h"
#import "HRCommonWebVC.h"
#import "HRBackAlertView.h"

@interface HRDealThatDeatilVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *p_imagePicker;
}
@property (nonatomic, strong)NSArray *templateArr;
@property (nonatomic, strong)NSArray *addresArr;
@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *templateLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UITextField *describeText;
@property (weak, nonatomic) IBOutlet UITextView *remarkText;
@property (weak, nonatomic) IBOutlet UICollectionView *pic_collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pic_collectionCont;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *sc_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sc_bottomLayoutCont;
@property (nonatomic, strong) TemplatesObj *tempObj;
@property (nonatomic, strong) NSString *link;

//提交接口需用值
@property (nonatomic) int get_way;//选取方式
@property (nonatomic) NSInteger language;//语言
@property (nonatomic, strong) NSString *address;//选中的地址
@property (nonatomic, strong) NSString *address_info;//选中的详细地址
@property (nonatomic, strong) NSString *recipient;//邮寄的地址
@property (nonatomic) int tpl_tid;//选中的模板id
@property (nonatomic, strong) NSString *tpl_form;//表单信息


@end

@implementation HRDealThatDeatilVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.proveName;
    
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"提交" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    
    [Net Templates:[Utils readUser].token Cid2:self.cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.templateArr = [TemplatesObj objectArrayWithKeyValuesArray:info[@"data"][@"templates"]];
            self.addresArr = [AddressObj objectArrayWithKeyValuesArray:info[@"data"][@"addrs"]];
            self.link =info[@"data"][@"link"];

            if(self.templateArr.count>0){
                self.templateLabel.text = [self.templateArr[0] name];
                self.tempObj = self.templateArr[0];

                self.tpl_tid = self.tempObj.id;//默认模板id
            }           
        }
    } FailBack:^(NSError *error) {
        DLog(@"error-->%@",error);

    }];
    
    //初始化默认值
    self.get_way = 2;
    self.language = 0;
    self.remarkText.text = @"";
    self.recipient = @"";
    self.address = @"";
    self.address_info = @"";
    self.tpl_form = @"";
    

    [self.pic_collection registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PicCollectionViewCell"];
    self.pic_collectionCont.constant = (self.pic_collection.width - 30)/3 + 20;//默认值

}

-(void)backAction{
    if (self.get_way == 2 && self.language == 0 && [self.describeText.text isEqualToString:@""]&&self.picspathArr.count == 0 && [self.remarkText.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showAlert];
    }
}

-(void)showAlert{
    HRBackAlertView *alert = [HRBackAlertView initBackAlertView];
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    __weak typeof(self)weakSelf = self;
    alert.backBlock = ^(NSInteger tag) {
        if (tag == 10) {//退出不保存草稿
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if (tag == 11){//退出并保存草稿
            [weakSelf SubmitApply:0];
        }else{//取消
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}
//提交订单
-(void)rightAction{
    if ([self.tpl_form isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"请填写模板"];
        return;
    }
    [self SubmitApply:1];
}

-(void)SubmitApply:(int)type{
    //上传图片拼接串
    NSString *images = @"";
    for (int i = 0; i < self.picspathArr.count; i++) {
        if (i == self.picspathArr.count - 1) {
            images = [images stringByAppendingString:[NSString stringWithFormat:@"%@",self.picspathArr[i]]];
        }else{
            images = [images stringByAppendingString:[NSString stringWithFormat:@"%@;",self.picspathArr[i]]];
        }
    }
    DLog(@"images-->%@",images);
    [Net SubmitApply:[Utils readUser].token
                Type:type
                City:[Utils getCity]
                Cid2:self.tempObj.cid2
                 Aid:self.aid
             Get_way:self.get_way
             Address:self.address
        Address_info:self.address_info
           Recipient:self.recipient
             Tpl_tid:self.tpl_tid
            Tpl_form:self.tpl_form
               Brief:self.describeText.text
             Comment:self.remarkText.text
            Language:self.language
              Images:images
             Attachs:@""
            CallBack:^(BOOL isSucc, NSDictionary *info) {
                if (isSucc) {
//                    NSLog(@"info-->%@",info);
                    if (type == 1) {//提交成功的操作
                        [Utils showMSG:@"提交成功"];
                        HRSuccessfulVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSuccessful"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{//保存草稿成功的操作
                        [Utils showMSG:@"保存草稿成功"];

                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } FailBack:^(NSError *error) {
                
            }];
}

- (IBAction)ded_click:(UIButton *)sender {
    DLog(@"sender-->%ld",(long)sender.tag);
    __weak typeof(self)weakSelf = self;
    switch (sender.tag - 100) {
        case 0:{//办理说明
            if(self.link){
                HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
                vc.link = self.link;
                vc.title = @"说明";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:{//领取方式
            HRWayModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRWayModel"];
            vc.fromVC = @"way";
            vc.title = @"领取方式";
            vc.addresArr = self.addresArr;
            //选取的方式
            vc.wmBlock = ^(int tag, NSString *str) {
                weakSelf.receiveLabel.text = str;
                weakSelf.get_way = tag;
            };
            //领取的地址
            vc.objBlock = ^(AddressObj *obj) {
                weakSelf.address = obj.address;
                weakSelf.address_info = obj.address_info;
            };
            //邮寄的地址
            vc.addBlock = ^(HRAddVO *vobj) {
                weakSelf.recipient = vobj.addr;
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{//选择模板
            if(self.templateArr.count == 0){
                [SVProgressHUD showImage:nil status:@"暂无模板！"];
                return;
            }
            HRWayModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRWayModel"];
            vc.fromVC = @"model";
            vc.title = @"选择模板";
            vc.templateArr = self.templateArr;
            //选取的模板
            vc.templateBlock = ^(TemplatesObj *obj) {
                weakSelf.tpl_tid = obj.id;
            };
            ////选取模板 拼接的表单信息
            vc.wtpBlock = ^(NSString *tpl_form) {
                weakSelf.tpl_form = tpl_form;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{//开具语言
            HRLanguageAlert *alert = [HRLanguageAlert initLanguageAlert];
            alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
            alert.languageBlock = ^(NSString *language,NSInteger tag) {
                weakSelf.languageLabel.text = language;
                self.language = tag;
            };
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
            break;
        case 4:{//描述
//            HRInputVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRInput"];
//            vc.inputBlock = ^(NSString *describe) {
//                weakSelf.describeLabel.text = describe;
//            };
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
     
        default:
            break;
    }
}

#pragma --mark UICollectionViewDelegate UICollectionViewDatasoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picspathArr.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"PicCollectionViewCell";
    PicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row != self.picspathArr.count) {
        [cell.picIma sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.picspathArr[indexPath.row]]] placeholderImage:nil] ;
        cell.celBtn.hidden = NO;
        cell.celBtn.tag = indexPath.row;
    }else{
        cell.picIma.image = [UIImage imageNamed:@"icon_upiantianjia"];
        cell.celBtn.hidden = YES;
    }
    __weak typeof(self)weakSelf = self;
    cell.picBlock = ^(NSInteger tag) {
        [weakSelf.picspathArr removeObjectAtIndex:tag];
        [weakSelf setConstant];
    };
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.pic_collection.width - 30)/3, (self.pic_collection.width - 30)/3);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.picspathArr.count) {

        SGImagePickerController *picker = [SGImagePickerController new];
        //返回选择的缩略图
        [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
            NSLog(@"缩略图%@",thumbnails);
            if (self.picspathArr.count > 8) {
                [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                return ;
            }
            [self uploadIma:thumbnails];
        }];
      
        //返回选中的原图
        //    [picker setDidFinishSelectImages:^(NSArray *images) {
        //        NSLog(@"原图%@",images);
        //    }];

        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)setConstant{
    if ((self.picspathArr.count + 1)%3 == 0) {
        self.pic_collectionCont.constant = (self.picspathArr.count + 1)/3 * ((self.pic_collection.width - 30)/3 + 10);
    }else{
        self.pic_collectionCont.constant = ((self.picspathArr.count + 1)/3 + 1) * ((self.pic_collection.width - 30)/3 + 10);
    }
    [self.pic_collection reloadData];
    
}

-(void)uploadIma:(NSArray *)pics{
    for (UIImage *img in pics) {
        [XQUploadHelper startSendImageName:@"file" image:img parameters:[NSDictionary dictionary] block:^(NSData *obj, id error) {
            if (!error)
            {
                NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
                NSString *url = dic[@"data"][@"path"];
                [self.picspathArr addObject:url];
                if (self.picspathArr.count>0) {
                    [self setConstant];
                }
                DLog(@"-->%@--->%@",dic,url);
                DLog(@"上传成功！");
            }
        }];
    }
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(NSMutableArray *)picspathArr{
    if (!_picspathArr) {
        _picspathArr = [NSMutableArray array];
    }
    return _picspathArr;
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [self keyboardFrame:notification];
    DLog(@"xxx-->%f",keyboardFrame.size.height);

    //  self.BottomLayoutConstaint.constant 这个是storyboard里面tableview的下沿，直接拉线的，而keyboardFrame.size.height是键盘的高度
    self.bottomLayoutCont.constant = keyboardFrame.size.height;
    
    [self.scroll setContentOffset:CGPointMake(0,self.sc_view.height - self.bottomLayoutCont.constant - 50) animated:YES];//滑动到底部
    
    [UIView animateWithDuration:[self duration:notification] delay:0 options:[self option:notification] animations:^{
        [self.scroll layoutIfNeeded];
    } completion:nil];
    
    
}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
    self.bottomLayoutCont.constant = 0;
    [UIView animateWithDuration:[self duration:notification] delay:0 options:[self option:notification] animations:^{
        [self.scroll layoutIfNeeded];
    } completion:nil];
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

//
//  HREmployeeModelVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HREmployeeModelVC.h"
#import "HRPicCollectionView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SGImagePickerController.h"
#import "HRBackAlertView.h"
#import "HRSuccessfulVC.h"
#import "HRCommonWebVC.h"
#import "HRDatePicker.h"

@interface HREmployeeModelVC ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tltLabel;
@property (weak, nonatomic) IBOutlet UILabel *cotLabel;
@property (weak, nonatomic) IBOutlet UITextView *briefText;
@property (weak, nonatomic) IBOutlet UIView *opreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *opreHeight;

@property (weak, nonatomic) IBOutlet HRPicCollectionView *picCView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCVconst;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *sc_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutCont;

@property (weak, nonatomic) IBOutlet UIView *picView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picsHc;

@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (nonatomic, strong)NSString *link;

@end

@implementation HREmployeeModelVC

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
    
    self.title = self.ndStr;
    self.typeLabel.text = self.ndStr;
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"提交" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    
    if (self.cid2 == 28){
        self.tltLabel.text = @"预约入职日期";
        self.cotLabel.text = [self getCurrentTime];
        
        //隐藏选择图片
        self.picsHc.constant = 0;
        self.picView.hidden = YES;
        self.picTopC.constant = -50;
        
    }else {
        self.opreView.hidden = YES;
        self.opreHeight.constant = 0;
    }
    
    [Net GetLink:[Utils readUser].token Cid2:self.cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
           self.link = info[@"data"][@"link"];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    __weak typeof(self)weakSelf = self;
    self.picCView.addPicBlock = ^() {
        SGImagePickerController *picker = [SGImagePickerController new];
        //返回选择的缩略图
        [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
            NSLog(@"缩略图%@",thumbnails);
            if (weakSelf.picspathArr.count > 8) {
                [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                return ;
            }
            [weakSelf uploadIma:thumbnails];
        }];
        
        //返回选中的原图
        //    [picker setDidFinishSelectImages:^(NSArray *images) {
        //        NSLog(@"原图%@",images);
        //    }];
        
        [self presentViewController:picker animated:YES completion:nil];
    };
    
    self.picCView.delPicBlock = ^(NSInteger tag) {
        [self.picspathArr removeObjectAtIndex:tag];
        [self setConstant];
    };
}

-(void)backAction{
    if(self.cid2 == 28){//预约入职
        if ([self.cotLabel.text isEqualToString: [self getCurrentTime]]&&[self.briefText.text isEqualToString:@""]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert];
        }
    }else{
        if(self.picspathArr.count == 0&&[self.briefText.text isEqualToString:@""]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert];
        }
    }
}
//获取当前时间 年月日格式
-(NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate:[NSDate date]];
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
    if (self.picspathArr.count==0 && self.cid2 != 28) {
        [SVProgressHUD showImage:nil status:@"请选择照片"];
        return;
    }
    [self SubmitApply:1];
}

#pragma mark -- 接口
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
    
    NSString *briefStr = @"";
    NSString *remarkStr = @"";
    if (self.cid2 == 28) {//预约入职
        briefStr = self.cotLabel.text;
        remarkStr = self.briefText.text;
    }else{
        briefStr = self.briefText.text;
    }

    [Net SubmitApply:[Utils readUser].token
                Type:type
                City:[Utils getCity]
                Cid2:self.cid2
                 Aid:self.aid
             Get_way:3
             Address:@""
        Address_info:@""
           Recipient:@""
             Tpl_tid:0
            Tpl_form:@""
               Brief:briefStr
             Comment:remarkStr
            Language:0
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
-(void)setConstant{
    self.picCView.picspathArr = self.picspathArr;
    if ((self.picspathArr.count + 1)%3 == 0) {
        self.picCVconst.constant = (self.picspathArr.count + 1)/3 * ((self.picCView.width - 30)/3 + 10);
    }else{
        self.picCVconst.constant = ((self.picspathArr.count + 1)/3 + 1) * ((self.picCView.width - 30)/3 + 10);
    }
    CGRect frame = self.picCView.pic_collection.frame;
    frame.size.height = self.picCVconst.constant;
    self.picCView.pic_collection.frame = frame;
    [self.picCView.pic_collection reloadData];
    
}
- (IBAction)em_click:(UIButton *)sender {
    
    if (sender.tag == 100) {
        if (self.link) {
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = self.link;
            vc.title = @"说明";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag == 101){
        if(self.cid2 == 28){//预约入职时间
            HRDatePicker *picker = [HRDatePicker initDatePicker];
            picker.frame = self.view.bounds;
            picker.dateBlock = ^(NSInteger tag, NSString *time) {
                if (tag == 2) {//确定
                    self.cotLabel.text = time;
                }
            };
            [self.view addSubview:picker];
        }
  
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

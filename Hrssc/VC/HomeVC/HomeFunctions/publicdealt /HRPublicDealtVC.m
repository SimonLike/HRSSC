
//
//  HRPublicDealtVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRPublicDealtVC.h"
#import "HRReceiveAddressVC.h"
#import "HRWayModelVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SGImagePickerController.h"
#import "HRPicCollectionView.h"
#import "HRCommonWebVC.h"
#import "HRBackAlertView.h"
#import "HRSuccessfulVC.h"
#import "HRCategory2ListObj.h"

@interface HRPublicDealtVC ()

@property (nonatomic, strong)NSArray *addresArr;
@property (nonatomic, strong)NSArray *templateArr;
@property (nonatomic, strong)NSMutableArray *picspathArr;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UITextView *briefText;
//图片View
@property (weak, nonatomic) IBOutlet HRPicCollectionView *picCView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCVconst;
//集体用户
@property (weak, nonatomic) IBOutlet UILabel *isNotLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pcomConst;
@property (weak, nonatomic) IBOutlet UIView *pcomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pconTopConst;
//领取方式
@property (weak, nonatomic) IBOutlet UIView *lq_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lq_contHit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lq_mb_cont;
//选择模板
@property (weak, nonatomic) IBOutlet UIView *mb_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mb_contHit;

@property (nonatomic, strong) NSString *link;
@property (weak, nonatomic) IBOutlet UILabel *mlyTabel;
//提交接口需用值
@property (nonatomic) int get_way;//选取方式
@property (nonatomic, strong) NSString *address;//选中的地址
@property (nonatomic, strong) NSString *address_info;//选中的详细地址
@property (nonatomic, strong) NSString *recipient;//邮寄的地址

@property (nonatomic) int tpl_tid;//选中的模板id
@property (nonatomic, strong) NSString *tpl_form;//表单信息
@end

@implementation HRPublicDealtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.hkName;
    self.typeLabel.text = self.hkName;
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"提交" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    
    if (self.cid2) {
        self.lq_mb_cont.constant = 0;
        if(self.cid2 == 19){//户口卡借用
            self.pcomConst.constant = 40;
            self.pconTopConst.constant = 10;
            self.isNotLabel.text = @"是";
            self.mb_view.hidden = YES;
            self.mb_contHit.constant = 0;
        
        }else{
            self.pcomConst.constant = 0;
            self.pconTopConst.constant = 0;
            self.pcomView.hidden = YES;
            self.isNotLabel.text = @"";
            self.mlyTabel.text = @"选择模板";
            self.receiveLabel.text = @"";
            self.lq_view.hidden = YES;
            self.lq_contHit.constant = 0;
        }
        [self Templates:self.cid2];
    }else{//
        self.pcomConst.constant = 0;
        self.pconTopConst.constant = 0;
        self.pcomView.hidden = YES;
        //获取二级子业务列表
        [Net Category2:[Utils readUser].token Cid:6 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
            if (isSucc) {
                NSArray *array = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
                self.cid2 = [(HRCategory2ListObj*)array[0] id];
                [self Templates:self.cid2];
            }
        } FailBack:^(NSError *error) {
            
        }];
    }
    
    //初始化默认值
    self.get_way = 2;
    self.recipient = @"";
    self.address = @"";
    self.address_info = @"";
    self.tpl_tid = 0;
    self.tpl_form = @"";
    
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
    if (self.cid2) {
        if(self.cid2 == 19){//户口卡借用
            if([self.briefText.text isEqualToString:@""] && self.get_way == 2 && self.picspathArr.count == 0 && [self.isNotLabel.text isEqualToString:@"是"]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showAlert];
            }
        }else{
            if([self.briefText.text isEqualToString:@""] && self.picspathArr.count == 0){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showAlert];
            }
        }
    }else{
        if([self.briefText.text isEqualToString:@""] && self.get_way == 2 && self.picspathArr.count == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert];
        }
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
    if ([self.briefText.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"请填写借用事由"];
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
    
    DLog(@"images-->%@",images);
    [Net SubmitApply:[Utils readUser].token
                Type:type
                City:[Utils getCity]
                Cid2:self.cid2
                 Aid:self.aid
             Get_way:self.get_way
             Address:self.address
        Address_info:self.address_info
           Recipient:self.recipient
             Tpl_tid:self.tpl_tid
            Tpl_form:self.tpl_form
               Brief:self.briefText.text
             Comment:self.isNotLabel.text
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

-(void)Templates:(int)cid2{
    [Net Templates:[Utils readUser].token Cid2:cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);
            self.addresArr = [AddressObj objectArrayWithKeyValuesArray:info[@"data"][@"addrs"]];
            self.templateArr = [TemplatesObj objectArrayWithKeyValuesArray:info[@"data"][@"templates"]];
            
            if(self.cid2 == 19){//户口卡借用
                if (self.templateArr.count>0) {
                    self.tpl_tid = [(TemplatesObj*)self.templateArr[0] id];
                    self.receiveLabel.text = [(TemplatesObj*)self.templateArr[0] name];
                }
            }else{
                self.get_way = 3;
            }
            self.link = info[@"data"][@"link"];
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (IBAction)pd_click:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    if(sender.tag == 100){//办理说明
        if (self.link) {
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = self.link;
            vc.title = @"说明";
            [self.navigationController pushViewController:vc animated:YES];
  
        }
    }else if (sender.tag == 101){//领取方式
        
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
      
    }else if (sender.tag == 102){// 选取模板
        if (self.templateArr.count == 0) {
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
            weakSelf.receiveLabel.text = obj.name;
            
        };
        ////选取模板 拼接的表单信息
        vc.wtpBlock = ^(NSString *tpl_form) {
            weakSelf.tpl_form = tpl_form;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103){//是否使用集体户
        sender.selected =!sender.selected;
        if (sender.selected) {
            self.isNotLabel.text = @"否";
        }else{
            self.isNotLabel.text = @"是";
        }
    }
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

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)picspathArr{
    if (!_picspathArr) {
        _picspathArr = [NSMutableArray array];
    }
    return _picspathArr;
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

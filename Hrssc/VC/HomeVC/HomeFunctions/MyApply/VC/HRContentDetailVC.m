//
//  HRContentDetailVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/27.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRContentDetailVC.h"
#import "HRCommonWebVC.h"
#import "HRWayModelVC.h"
#import "HRInputVC.h"
#import "HRPicCollectionView.h"
#import "HRAttachsView.h"
#import "HRWebViewVC.h"
#import "TemplatesObj.h"


@interface HRContentDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *handleCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (weak, nonatomic) IBOutlet UIView *picHpView;
//图片
@property (weak, nonatomic) IBOutlet HRPicCollectionView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tp_heightCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pic_attach_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pic_bottom;
//附件
@property (weak, nonatomic) IBOutlet UIView *attchSpView;
@property (weak, nonatomic) IBOutlet HRAttachsView *attachView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachHeightCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fj_heightCont;
//领取方式
@property (weak, nonatomic) IBOutlet UIView *receiveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveTop;
//描述
@property (weak, nonatomic) IBOutlet UIView *describeView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ms_tLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeTop;
//备注
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *bz_tLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTop;

//模板
@property (weak, nonatomic) IBOutlet UIView *modelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modelTop;

//提交接口需用值
@property (nonatomic) int get_way;//选取方式
@property (nonatomic, strong) NSString *address;//选中的地址
@property (nonatomic, strong) NSString *address_info;//选中的详细地址
@property (nonatomic, strong) NSString *recipient;//邮寄的地址
@property (nonatomic) int tpl_tid;//选中的模板id
@property (nonatomic, strong) NSString *tpl_form;//表单信息

@end

@implementation HRContentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内容详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.handleCityLabel.text = self.detailObj.city;
    
    if (self.detailObj.get_way == 0 || self.detailObj.get_way == 1 || self.detailObj.get_way == 2) {
        switch (self.detailObj.get_way) {//0:自取 1:邮寄, 2打印
            case 0:
                self.selfHelpLabel.text = @"自助领取";
                break;
            case 1:
                self.selfHelpLabel.text = @"邮寄";
                break;
            case 2:
                self.selfHelpLabel.text = @"自助打印";
                break;
                
            default:
                break;
        }
    }else{
        self.receiveView.hidden = YES;
        self.receiveTop.constant = 0;
        self.receiveHeight.constant = 0;
    }
    self.timeLabel.text = self.detailObj.create_time;
   
    //备注
    if (self.detailObj.pageid == 2 || self.detailObj.cid2 == 23 || self.detailObj.cid2 == 18 || self.detailObj.cid2 == 28 ) {//户口办理类
        if (self.detailObj.cid2 == 19) {//户口卡借用
            self.bz_tLabel.text = @"借用事由";
            self.ms_tLabel.text = @"是否使用集体户";
            [self remarkModule:self.detailObj.brief];
            [self describeModule:self.detailObj.comment];
        }else if (self.detailObj.cid2 == 28) {//预约入职类
            self.ms_tLabel.text = @"预约入职时间";
            [self remarkModule:self.detailObj.comment];
            [self describeModule:self.detailObj.brief];
        }else{
            self.bz_tLabel.text = @"申请说明";
            [self remarkModule:self.detailObj.brief];
            [self describeModule:@""];
        }
    }else if (self.detailObj.cid2 == 27 || self.detailObj.cid2 == 26) {//学位验证 工卡照片
        [self remarkModule:self.detailObj.brief];
        [self describeModule:@""];
    }else{//备注
        
        [self remarkModule:self.detailObj.comment];
        [self describeModule:self.detailObj.brief];

    }
    
//    self.remarkLabel.text = self.detailObj.comment;
//    if ([self.detailObj.comment isEqualToString:@""]) {
//        self.remarkView.hidden = YES;
//        self.remarkHeight.constant = 0;
//        self.remarkTop.constant = - 20;
//    }
//    
//    if ([self.detailObj.brief isEqualToString:@""]) {
//        self.describeView.hidden = YES;
//        self.describeTop.constant = 0;
//        self.describeHeight.constant = 0;
//    }else{
//        self.describeLabel.text = self.detailObj.brief;
//        
//    }
    
    
    //附件
    if([self.detailObj.attachs isEqualToString:@""]){
        self.attchSpView.hidden = YES;
        self.attachHeightCont.constant = 0;
        self.fj_heightCont.constant = 0;
        self.pic_attach_Top.constant = -2;
    }else{
        [self attachs:[self.detailObj.attachs componentsSeparatedByString:@";"]];
    }
    //图片
    if([self.detailObj.images isEqualToString:@""]){
        self.picHpView.hidden = YES;
        self.picHeightCont.constant = 0;
        self.tp_heightCont.constant = 0;
        self.pic_bottom.constant = -2;
    }else{
        [self pics:[self.detailObj.images componentsSeparatedByString:@";"]];
    }

    
    //模板
    if ([self.detailObj.tpl_name isEqualToString:@""]) {
        self.modelView.hidden = YES;
        self.modelTop.constant = 0;
        self.modelHeight.constant = 0;
    }else{
        self.modelLabel.text = self.detailObj.tpl_name;
    }

    
    /*
     pageid	二级页面名称	适用模块
     1	证明提交类	证明办理->所有二级页面
     社保->社保变更、社保/医保卡办理、社保转入、社保转出、医疗备案、社保报销、社保证明
     公积金->住房公积金变更、住房公积金联名卡、住房公积金证明
     2	户口办理类	户口办理->所有二级页面
     3	学位验证类	新员工->学位验证
     4	工卡照片类	新员工->工卡照片
     5	预约入职类	新员工->预约入职
     6	报到查询页	新员工->报到地址
     7	体检查询页	新员工->体检
     8	社保查询页	社保->社保缴纳详情
     9	公积金查询页	公积金->公积金缴纳详情
     10	查询跳转页	支持二级业务直接跳转到指定的URL
     */
    
    if(self.detailObj.pageid == 1){//证明提交类
        
        
    }
    
    switch (self.detailObj.status) {//状态：0待审核，1待办理，2待领取，3待评价，4已完成,5-已驳回 ，6-草稿箱
        case 0://待审核
            if(self.detailObj.pageid == 1){//证明提交类
                
            }
            break;
        case 1://待办理
            break;
        case 2://待领取
            
            break;
        case 3://待评价
            
            break;
        case 4://已完成
            
            break;
        case 5://已驳回
            break;
            
        default:
            break;
    }
    
    //附件点击事件
    __weak typeof(self)weakSelf = self;
    self.attachView.attachsBlock = ^(NSString *str) {
        HRWebViewVC *vc = [HRWebViewVC new];
        vc.typeUrl = @"attach";
        vc.attachStr = str;
        vc.tpBlock = ^(NSString *tpl_form) {
            
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
//备注 申请说明 借用事由
-(void)remarkModule:(NSString *)str{
    if ([str isEqualToString:@""]) {
        self.remarkLabel.text = @"";
        self.remarkView.hidden = YES;
        self.remarkHeight.constant = 0;
        self.remarkTop.constant = - 20;
        
    }else{
        self.remarkLabel.text = str;
    }
}
//描述 是否使用集体户
-(void)describeModule:(NSString *)str{
    if ([str isEqualToString:@""]) {
        self.describeLabel.text = @"";
        self.describeView.hidden = YES;
        self.describeTop.constant = 0;
        self.describeHeight.constant = 0;
       
    }else{
        self.describeLabel.text = str;
    }
}

//图片
-(void)pics:(NSArray *)array{
    self.picView.picTypeTnt = 1;//显示
    self.picView.picspathArr = array;
    
    if (array.count%3 == 0) {
        self.picHeightCont.constant = array.count/3 * ((self.picView.width - 30)/3 + 10);
    }else{
        self.picHeightCont.constant = (array.count/3 + 1) * ((self.picView.width - 30)/3 + 10);
    }
    CGRect frame = self.picView.pic_collection.frame;
    frame.size.height = self.picHeightCont.constant;
    self.picView.pic_collection.frame = frame;
    
    [self.picView.pic_collection reloadData];
}

//附件
-(void)attachs:(NSArray *)array{
    [self.attachView setAttachpathArr:array];
    self.attachHeightCont.constant = 32 * array.count + 14;
}

- (IBAction)cd_click:(UIButton *)sender {
    DLog(@"sender-->%ld",(long)sender.tag);
    __weak typeof(self)weakSelf = self;
    switch (sender.tag - 10) {
        case 0:{//办理说明
            if(self.detailObj.link){
                HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
                vc.link = self.detailObj.link;
                vc.title = @"说明";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:{//领取方式
//            HRWayModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRWayModel"];
//            vc.fromVC = @"way";
//            vc.title = @"领取方式";
////            vc.addresArr = self.addresArr;
//            //选取的方式
//            vc.wmBlock = ^(int tag, NSString *str) {
//                weakSelf.selfHelpLabel.text = str;
//                weakSelf.get_way = tag;
//            };
//            //领取的地址
//            vc.objBlock = ^(AddressObj *obj) {
//                weakSelf.address = obj.address;
//                weakSelf.address_info = obj.address_info;
//            };
//            //邮寄的地址
//            vc.addBlock = ^(HRAddVO *vobj) {
//                weakSelf.recipient = vobj.addr;
//            };
//            
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{//日期
//            HRLanguageAlert *alert = [HRLanguageAlert initLanguageAlert];
//            alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
//            alert.languageBlock = ^(NSString *language,NSInteger tag) {
//                weakSelf.languageLabel.text = language;
//                self.language = tag;
//            };
//            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
            break;
        case 3:{//描述
//            HRInputVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRInput"];
//            vc.inputBlock = ^(NSString *describe) {
//                weakSelf.describeLabel.text = describe;
//            };
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{//模板
            HRWebViewVC *vc = [HRWebViewVC new];
            vc.typeUrl = @"showNotR";
            TemplatesObj *obj = [[TemplatesObj alloc] init];
            obj.template = self.detailObj.tpl_content;
            obj.name = self.detailObj.tpl_name;
            vc.templatesObj = obj;

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
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

//
//  HRApplyDetailObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/15.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyDetailObj : NSObject
/* "apply":  */
@property (nonatomic) int id;//申请id
@property (nonatomic) int uid;//用户id
@property (nonatomic, copy) NSString *result;//被驳回的理由
@property (nonatomic, copy) NSString *attachs;//附件
@property (nonatomic, copy) NSString *link;//帮助链接，是绝对链接，直接跳转
@property (nonatomic, copy) NSString *address_info;//自取地址详细
@property (nonatomic, copy) NSString *work_order;//工单号
@property (nonatomic, copy) NSString *print_code;//打印码
@property (nonatomic, copy) NSString *tpl_content;//模板内容，直接展示html即可
@property (nonatomic, copy) NSString *recipient;//邮寄地址
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *postal_number;//运单号
@property (nonatomic, copy) NSString *deal_name;//办理业务员名称
@property (nonatomic, copy) NSString *name;//业务名称
@property (nonatomic, copy) NSString *tpl_form;//表单参数
@property (nonatomic, copy) NSString *tpl_name;//模板名称
@property (nonatomic, copy) NSString *tpl_document;//表单生成文档的路径，下载的话需要拼接文件上传的域名
@property (nonatomic) int pageid;//使用的页面类型
@property (nonatomic) int print_status;// 打印状态  0-打印失败 1-打印成功 2-未打印
@property (nonatomic) int status;//状态：0待审核，1待办理，2待领取，3待评价，4已完成,5-已驳回 ，6-草稿箱
@property (nonatomic) int cid2;//二级业务id
@property (nonatomic, copy) NSString *aid_deal;//办理员用户名 （不展示，展示的是业务员名称）
@property (nonatomic) int cid1;//一级业务id
@property (nonatomic) int postal_type;//邮件类型 -1 无快递公司      0 其他快递
@property (nonatomic) int tpl_tid;//模板id
@property (nonatomic, copy) NSString *ext1;//扩展字段1
@property (nonatomic, copy) NSString *ext2;//扩展字段2
@property (nonatomic, copy) NSString *audit_name;//审核员名称
@property (nonatomic, copy) NSString *address;//自取地址名称
@property (nonatomic, copy) NSString *create_time;//创建申请时间
@property (nonatomic, copy) NSString *images;//图片
@property (nonatomic, copy) NSString *audit_time;//审核时间
@property (nonatomic) int get_way;//领取方式：0:自取 1:邮寄, 2打印
@property (nonatomic) int language;//语言：0中文 1英文
@property (nonatomic, copy) NSString *comment;//备注
@property (nonatomic, copy) NSString *brief;//描述
@property (nonatomic, copy) NSString *aid_audit;//审核员用户名（不展示，展示的是审核员名称）

@end

@interface ProgressListObj : NSObject
/* "progressList":  */
@property (nonatomic) int id;//进度ID
@property (nonatomic, copy) NSString *attachs;//附件
@property (nonatomic, copy) NSString *admin;//添加人员用户名（不展示）
@property (nonatomic, copy) NSString *deal_name;//添加人员名称
@property (nonatomic, copy) NSString *create_time;//
@property (nonatomic, copy) NSString *images;//图片
@property (nonatomic) int appid;//申请ID
@property (nonatomic, copy) NSString *comment;//进度说明

@end

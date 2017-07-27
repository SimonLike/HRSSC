//
//  AddressDetialVC.m
//  Beautiful
//
//  Created by S on 16/1/26.
//  Copyright © 2016年 B. All rights reserved.
//

#import "AddressDetialVC.h"
#import "AreaPickView.h"
@interface AddressDetialVC ()
{
    AreaPickView *city_picker;
    NSString* provinceStr;
    NSString* cityStr;
    NSString* countryStr;
}
@end

@implementation AddressDetialVC

- (void)setUI
{
    //self.title = @"地址管理";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"f0f2f5"];
    
    UIButton* backBtn = [Utils createButtonWith:CustomButtonType_Back text:nil];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    if(_adType != 1)
    {
        _name.text = _currentVO.name;
        _tel.text = _currentVO.phone;
        _areaLabel.text = [NSString stringWithFormat:@"%@%@%@",_currentVO.prov,_currentVO.city,_currentVO.area];
        _detial.text = _currentVO.addr;
        provinceStr = _currentVO.prov;
        cityStr = _currentVO.city;
        countryStr = _currentVO.area;
    }
    /******************lxf**********************/
    [self viewWillAppear:YES];
    city_picker = [AreaPickView getInstanceWithThirdNibWithBlock:^(NSString *aStr, NSString *bStr, NSString *cStr) {
        provinceStr = aStr;
        cityStr = bStr;
        countryStr = cStr;
        _areaLabel.text = [NSString stringWithFormat:@"%@%@%@",aStr,bStr,cStr];
    }];
    CGRect pFrame = city_picker.frame ;
    pFrame.origin.y = SCREEN_HEIGHT;//CGRectGetHeight(self.view.bounds);
    pFrame.size.width = SCREEN_WIDTH;
    city_picker.frame = pFrame;
    city_picker.superViewDelegate = self;
     
    [self.view addSubview:city_picker];
    //[city_picker hide];
    

    NSString *path =[[NSBundle mainBundle] pathForResource:@"citys" ofType:@"plist"];
    NSArray *citys =[[NSArray alloc] initWithContentsOfFile:path];

    NSMutableDictionary* areaDic = [[NSMutableDictionary alloc] init];

    for (NSDictionary *p_dict in citys) {
        NSMutableDictionary *dictc2 = [NSMutableDictionary dictionary];
        for (NSDictionary *c_dict in p_dict[@"cities"]) {
            [dictc2 setValue:c_dict[@"areas"] forKey:c_dict[@"city"]];
        }
        [areaDic setValue:dictc2 forKey:p_dict[@"province"]];
    }

    [city_picker setCityD:areaDic];
//    if([[NSUserDefaults standardUserDefaults] objectForKey:CITYAREAS])
//        [city_picker setCityD:[[NSUserDefaults standardUserDefaults] objectForKey:CITYAREAS]];
//    else
//        [self AreaGet];
    //[area_picker setYearArray:shen];
    city_picker.pickType = Pick_City;
    //[area_picker setDataArray:[NSMutableArray arrayWithObjects:@"家居类",@"电动类",@"产品类",@"饮食类", nil]];
    /******************lxf**********************/
    [Utils cornerView:_saveBtn withRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
}

- (IBAction)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [city_picker hide];
}

- (void)AreaGet
{
//    [[NetWork shareInstance] AreaGet:[Utils readUnarchiveHistoryGoodsVOsAry].token callBack:^(MKNetworkOperation *completedOperation) {
//        NSError *error;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableLeaves error:&error];
//        //这里可能会加入错误码的判断
//        if (!error)
//        {
//            if([dic[@"status"] intValue] == 0)
//            {
//                [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"] forKey:CITYAREAS];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                [city_picker setCityD:[[NSUserDefaults standardUserDefaults] objectForKey:CITYAREAS]];
//            }
//            else
//            {
//                [[XQTipInfoView getInstanceWithNib] appear:@"地址信息获取失败"];
//                [self clickBack:nil];
//            }
//        }
//        else
//        {
//            [[XQTipInfoView getInstanceWithNib] appear:@"地址信息获取失败"];
//            [self clickBack:nil];
//        }
//    }];
}

- (IBAction)citySelect:(id)sender
{
    [city_picker appear];
    [self.name resignFirstResponder];
    [self.tel resignFirstResponder];
    [self.detial resignFirstResponder];
}

- (IBAction)save:(id)sender
{
    if([_name.text isEqualToString:@""])
    {
        TTAlert(@"请输入姓名");
        return;
    }
    if([_tel.text isEqualToString:@""]||_tel.text.length != 11)
    {
        TTAlert(@"请输入正确的电话号码");
        return;
    }
    if([self.areaLabel.text isEqualToString:@"请选择地区"])
    {
        TTAlert(@"请选择区域");
        return;
    }
    if([_detial.text isEqualToString:@""])
    {
        TTAlert(@"请输入详细地址");
        return;
    }
    if(_adType == 1)
    {
        [Net AddressAdd:[Utils readUser].token Name:_name.text Phone:_tel.text Prov:provinceStr City:cityStr Area:countryStr Addr:_detial.text CallBack:^(BOOL isSucc, NSDictionary *info) {
            if(isSucc)
            {
                [[XQTipInfoView getInstanceWithNib] appear:@"添加成功"];
                [self clickBack:nil];
            }
            else
            {
                
            }
        } FailBack:^(NSError *error) {
            
        }];
    }
    else
    {
        [Net AddressEdit:[Utils readUser].token Aid:_aId Name:_name.text Phone:_tel.text Prov:provinceStr City:cityStr Area:countryStr Addr:_detial.text CallBack:^(BOOL isSucc, NSDictionary *info) {
            if(isSucc)
            {
                [[XQTipInfoView getInstanceWithNib] appear:@"修改成功"];
                [self clickBack:nil];
            }
            else
            {
                
            }
        } FailBack:^(NSError *error) {
            
        }];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.name resignFirstResponder];
    [self.tel resignFirstResponder];
    [self.detial resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    
    if(textField == self.tel)
    {
        if(([@"0123456789" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.tel.text.length>=11&&range.length==0))
            return NO;
        else
            return YES;
    }
    else
        return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.name resignFirstResponder];
    [self.tel resignFirstResponder];
    [self.detial resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

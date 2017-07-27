
//
//  HREvaluationVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HREvaluationVC.h"
#import "HRStarsView.h"

@interface HREvaluationVC ()
@property (weak, nonatomic) IBOutlet HRStarsView *starsView;
@property (weak, nonatomic) IBOutlet HRStarsView *starsView2;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordNoLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UIView *evaluateTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateTagsHeight;
@property (weak, nonatomic) IBOutlet UITextView *textView2;

@property (strong, nonatomic) NSArray *eTagsArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *sc_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutCont;

//接口需传数据
@property (assign, nonatomic) int star1;
@property (assign, nonatomic) int star2;

@property (strong, nonatomic) NSMutableArray *selectTagsArray;

@end

@implementation HREvaluationVC
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
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"提交" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    self.wordNoLabel.text = [NSString stringWithFormat:@"NO.%@",self.work_order];
    self.typeLabel.text = self.name;
    
    [Utils cornerView:self.textView2 withRadius:0 borderWidth:1 borderColor:RGBCOLOR16(0xeeeeee)];

    //服务表现列表接口
    [Net EvaluateTags:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.eTagsArray = info[@"data"][@"tags"];
            [self setETagsView];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    __weak typeof(self)weakSelf = self;
    self.starsView.starsBlock = ^(int star) {
        weakSelf.star1 = star;
    };
    self.starsView2.starsBlock = ^(int star) {
        weakSelf.star2 = star;
    };
}
//评价提交
-(void)rightAction{
    
    NSString *tags = @"";
    for (int i = 0; i < self.selectTagsArray.count; i++) {
        if (i == self.selectTagsArray.count - 1) {
            tags = [tags stringByAppendingString:[NSString stringWithFormat:@"%@",self.selectTagsArray[i]]];
        }else{
            tags = [tags stringByAppendingString:[NSString stringWithFormat:@"%@;",self.selectTagsArray[i]]];
        }
    }
    
    [Net EvaluateApply:[Utils readUser].token Aid:self.aid Star1:self.star1 Star2:self.star2 Comment1:self.textView1.text Comment2:self.textView2.text Tag:tags CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            if (self.successBlock) {
                self.successBlock();//提交评价成功 返回提示刷新
            }
        }
    } FailBack:^(NSError *error) {
        
    }];
}

//服务列表
-(void)setETagsView{
    
    self.evaluateTagsHeight.constant = 74;
    for (int i = 0; i < self.eTagsArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( i%3 * 97 , i/3 * 42, 87, 32);
        [button setTitle:self.eTagsArray[i] forState:UIControlStateNormal];
        button.tag = 10 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(s_click:) forControlEvents:UIControlEventTouchUpInside];
        [Utils cornerView:button withRadius:16 borderWidth:1 borderColor:RGBCOLOR16(0xdddddd)];
        [self.evaluateTagsView addSubview:button];
    }
}

-(void)s_click:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [sender setBackgroundColor:RGBCOLOR(23, 144, 210)];
        [self.selectTagsArray addObject:self.eTagsArray[sender.tag - 10]];
    }else{
        [sender setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        [sender setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [self.selectTagsArray removeObject:self.eTagsArray[sender.tag - 10]];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"输入你的意见&建议（选填）"]) {
        textView.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"输入你的意见&建议（选填）";
    }
    return YES;
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    
    if (self.textView2.isFirstResponder) {
        CGRect keyboardFrame = [self keyboardFrame:notification];
        //  self.BottomLayoutConstaint.constant 这个是storyboard里面tableview的下沿，直接拉线的，而keyboardFrame.size.height是键盘的高度
        self.bottomLayoutCont.constant = keyboardFrame.size.height;
        [self.scroll setContentOffset:CGPointMake(0,self.sc_view.height - self.bottomLayoutCont.constant - 50) animated:YES];//滑动到底部
        
        [UIView animateWithDuration:[self duration:notification] delay:0 options:[self option:notification] animations:^{
            [self.scroll layoutIfNeeded];
        } completion:nil];
    }

}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
    if (self.textView2.isFirstResponder) {
        self.bottomLayoutCont.constant = 0;
        [UIView animateWithDuration:[self duration:notification] delay:0 options:[self option:notification] animations:^{
            [self.scroll layoutIfNeeded];
        } completion:nil];
    }
}


-(NSMutableArray *)selectTagsArray{
    if (!_selectTagsArray) {
        _selectTagsArray = [NSMutableArray array];
    }
    return _selectTagsArray;
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

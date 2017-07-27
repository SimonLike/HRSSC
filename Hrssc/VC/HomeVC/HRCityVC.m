//
//  HRCityVC.m
//  Hrssc
//
//  Created by admin on 17/4/24.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRCityVC.h"
#import "ChineseString.h"
#import "pinyin.h"
@interface HRCityVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* cityTable;
    NSMutableArray *sortedArrForArrays;
    NSMutableArray *sectionHeadsKeys;
}
@end

@implementation HRCityVC

- (void)backAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"办理城市";
    [self setUpCityData];
    [self setUpTable];
}

- (void)setUpCityData
{
    NSArray* dataArray = [Utils readCityData];
    NSMutableArray* cityArray = [[NSMutableArray alloc] init];
    sortedArrForArrays = [[NSMutableArray alloc] init];
    sectionHeadsKeys = [[NSMutableArray alloc] init];
    for(HRCityVO* vo in dataArray)
    {
        [cityArray addObject:vo.city];
    }
    sortedArrForArrays = [self getChineseStringArr:cityArray];
}

- (void)setUpTable
{
    cityTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    cityTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    cityTable.backgroundColor = [UIColor clearColor];
    cityTable.delegate = self;
    cityTable.dataSource = self;
    [cityTable setSectionIndexColor:[UIColor lightGrayColor]];
    [self.view addSubview:cityTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionHeadsKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)[sortedArrForArrays objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionHeadsKeys objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"key";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = str.string;
        } else {
            ;
        }
    } else {
        ;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_cBlock)
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        _cBlock(cell.textLabel.text);
    }
    [self backAction];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionHeadsKeys;
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //        NSLog(@"%@",sr);
        if(![sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] init];
            checkValueAtIndex = NO;
        }
        if([sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

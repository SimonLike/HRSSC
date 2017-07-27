//
//  CityPickerView.m
//  PlistDemo
//
//  Created by Wei Wang on 11/6/13.
//  Copyright (c) 2013 weiwang. All rights reserved.
//

#import "CityPickerView.h"

@interface  CityPickerView()
@property (nonatomic, strong) NSMutableArray *allCityArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *thirdArray;
@property (nonatomic, strong) NSMutableArray *lastChoose;

@end

@implementation CityPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp:frame];
    }
    return self;
}
- (void) setUp:(CGRect)frame {
    self.allCityArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.cityArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.thirdArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.lastChoose = [[NSMutableArray alloc] initWithCapacity:0];
    self.proviceDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    for (NSString *key in [dict allKeys]) {
        [self.allCityArray addObject:[dict objectForKey:key]];
    }
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:self.bounds];
    pick.showsSelectionIndicator = YES;
    pick.delegate = self;
    pick.dataSource = self;
    [self addSubview:pick];
    [pick selectRow:29 inComponent:0 animated:NO];
    [self selectIndex:29];
    [pick reloadAllComponents];
    [self.proviceDictionary setObject:@"北京市" forKey:@"provice"];
    [self.proviceDictionary setObject:@"北京市" forKey:@"city"];
    [self.proviceDictionary setObject:@"东城区" forKey:@"county"];
    
}

- (void)dataInit
{
    [self.delegate updateLabel];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.allCityArray.count;
    }
    if (component == 1) {
        return self.cityArray.count;
    }
    return self.lastChoose.count;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        NSString *key = [[self.allCityArray[row] allKeys] lastObject];
        return key;
    } if (component == 1) {
        return self.cityArray [row];
    }
    return self.lastChoose[row];
}
- (void)selectIndex:(NSInteger)index {
    [self.cityArray removeAllObjects];
    [self.thirdArray removeAllObjects];
    [self.lastChoose removeAllObjects];
    
    NSString *key = [[self.allCityArray[index] allKeys] lastObject];
    NSDictionary *dictCity = [self.allCityArray[index] objectForKey:key];
    for (NSString * k in [dictCity allKeys]) {
        NSDictionary *dict = [dictCity objectForKey:k];
        for (NSString *cityName in [dict allKeys]) {
            [self.cityArray addObject:cityName];
            
            [self.thirdArray addObject:[dict objectForKey:cityName]];
        }
    }
    [self.lastChoose addObjectsFromArray:self.thirdArray[0]];
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [self selectIndex:row];
        [pickerView reloadAllComponents];
        [self.proviceDictionary setObject:[[self.allCityArray[row] allKeys] lastObject] forKey:@"provice"];
        [self.proviceDictionary setObject:self.cityArray[0] forKey:@"city"];
        [self.proviceDictionary setObject:self.lastChoose[0] forKey:@"county"];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } if (component == 1) {
        [self.lastChoose removeAllObjects];
        [self.lastChoose addObjectsFromArray:self.thirdArray[row]];
        [pickerView reloadComponent:2];
        [self.proviceDictionary setObject:self.cityArray[row] forKey:@"city"];
        [self.proviceDictionary setObject:self.lastChoose[0] forKey:@"county"];
        [pickerView selectRow:0 inComponent:2 animated:NO];
       
    } else if (component == 2){
       [self.proviceDictionary setObject:self.lastChoose[row] forKey:@"county"];
    }

    [self.delegate updateLabel];

}


@end

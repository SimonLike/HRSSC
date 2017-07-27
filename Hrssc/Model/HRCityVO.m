//
//  HRCityVO.m
//  Hrssc
//
//  Created by admin on 17/4/22.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRCityVO.h"

@implementation HRCityVO
- (void)dealloc
{
}
//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.create_time forKey:@"create_time"];
    [encoder encodeObject:self.defaultOrNot forKey:@"defaultOrNot"];
    [encoder encodeObject:self.word forKey:@"word"];
    [encoder encodeObject:self.city forKey:@"city"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.create_time = [decoder decodeObjectForKey:@"create_time"];
        self.defaultOrNot = [decoder decodeObjectForKey:@"defaultOrNot"];
        self.word = [decoder decodeObjectForKey:@"word"];
        self.city = [decoder decodeObjectForKey:@"city"];
    }
    return self;
}

@end

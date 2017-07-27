//
//  UserVO.m
//  Beautiful
//
//  Created by S on 16/1/25.
//  Copyright © 2016年 B. All rights reserved.
//

#import "UserVO.h"

@implementation UserVO
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
    [encoder encodeObject:self.account forKey:@"account"];
    [encoder encodeObject:self.uin forKey:@"uin"];
    [encoder encodeObject:self.signature forKey:@"signature"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.head forKey:@"head"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.login_time forKey:@"login_time"];
    [encoder encodeObject:self.creat_time forKey:@"creat_time"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.marry forKey:@"marry"];
    [encoder encodeObject:self.minority forKey:@"minority"];
    [encoder encodeObject:self.id_card forKey:@"id_card"];
    [encoder encodeObject:self.amount forKey:@"amount"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.account = [decoder decodeObjectForKey:@"account"];
        self.uin = [decoder decodeObjectForKey:@"uin"];
        self.signature = [decoder decodeObjectForKey:@"signature"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.head = [decoder decodeObjectForKey:@"head"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.login_time = [decoder decodeObjectForKey:@"login_time"];
        self.creat_time = [decoder decodeObjectForKey:@"creat_time"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.marry = [decoder decodeObjectForKey:@"marry"];
        self.minority = [decoder decodeObjectForKey:@"minority"];
        self.id_card = [decoder decodeObjectForKey:@"id_card"];
        self.amount = [decoder decodeObjectForKey:@"amount"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
    }
    return self;
}
@end

//
//  HMPerson.m
//  MVVM模式测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "HMPerson.h"

@implementation HMPerson

+(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    HMPerson *person = [[HMPerson alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    
    return person;
}

@end
